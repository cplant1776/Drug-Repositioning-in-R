#This Rscript sorts gene-expression based drug repo results (treatment ids with scores)
library(plyr)
library(ggplot2)
library(data.table)
library("argparse")

parser <- ArgumentParser(description="")
parser$add_argument("-n", action="store", dest="inst_dir", required=TRUE, help="inst.csv location")
parser$add_argument("-L", action="store", dest="irrelevant_dir", required=TRUE, help="irrelevant.csv location")
args <- parser$parse_args()
inst_dir <- args$inst_dir
irrelevant_dir <- args$irrelevant_dir

local_rds = list.files(pattern='*.rds') # find rds in cwd
input = substr(local_rds,1,nchar(local_rds)-4)
readRDS(local_rds)->a # read in RDS

######################
## Sort up/down IDs by score ##
######################
# convert current row names into first column and sort by score
setDT(a, keep.rownames=TRUE)[]
sorted=arrange(a,desc(a$result))

# get sorted columns of most-extreme up and down regulated treatments
result_up=head(sorted,300) # take 300 most-extreme up
result_down=tail(sorted,300) # take 300 most-extreme down
sort.result_up <- with(result_up,  result_up[order(rn) , ])
sort.result_down <- with(result_down,  result_down[order(rn) , ])
up_score=sort.result_up$result
down_score=sort.result_down$result
outup = matrix(, ncol=1, byrow=T)
result_up = t(result_up)
result_down = t(result_down)

######################
## Map treatment IDs to names ##
######################
#read actual names from inst.info
d_t_map = read.csv(inst_dir, sep='\t', header=T)
master_list = cbind(as.matrix(d_t_map[,1]), as.matrix(d_t_map[,3]))

# up
xup = master_list[master_list[,1] %in% result_up]
yup = length(xup)
nameup = head(xup, -(yup/2))
drugup = tail(xup, -(yup/2))
outup = cbind(nameup, drugup)
outup=as.data.frame(outup)
sort.outup <- with(outup,  outup[order(nameup) , ]) #sort it alphabeticly
finalup_alpha=cbind(sort.outup, up_score)
finalup_beta=arrange(finalup_alpha,desc(finalup_alpha$up_score))

# down
xdown = master_list[master_list[,1] %in% result_down]
ydown = length(xdown)
namedown = head(xdown, -(ydown/2))
drugdown = tail(xdown, -(ydown/2))
outdown = cbind(namedown, drugdown)
outdown=as.data.frame(outdown)
sort.outdown <- with(outdown,  outdown[order(namedown) , ]) #sort it alphabeticly
finaldown_alpha=cbind(sort.outdown, down_score)
finaldown_beta=arrange(finaldown_alpha,desc(finaldown_alpha$down_score))

######################
## Filter out irrelevant treatments ##
######################
master_list = read.csv(irrelevant_dir, sep='\t', header=F) #import as data.frame
master_list = as.character(unlist(master_list)) #convert to vector

# down
outputdown = subset(finaldown_beta, !(drugdown %in% master_list)) #filter out irrelevant treatments
wordsdown=paste(input, 'drug_down.tsv', sep="_")
write.table(outputdown, file = wordsdown, quote = FALSE, sep = '\t', row.names = F, col.names = F) #save file

# up
outputup = subset(finalup_beta, !(drugup %in% master_list)) # filter out irrelevant treatments
wordsup=paste(input, 'drug_up.tsv', sep="_")
write.table(outputup, file = wordsup, quote = FALSE, sep = '\t', row.names = F, col.names = F) #save file

######################
## Graph raw scores ##
######################
x = readRDS(local_rds)
x = data.frame(rownames(x), x$result)
names(x) = c('name', 'val')
x = x[order(x$val), ]
x$name = factor(x$name, levels = x$name[order(x$val)])
x_subset = x[seq(1, nrow(x), 1000), ] # sample every 1000th row

raw_distribution = ggplot(x_subset,aes(name,val))+
   geom_bar(stat="identity",position = "identity")+
   theme(axis.text.x = element_blank())+
   xlab("drugs") +
   ylab("score")

ggsave(filename="raw_distribution.jpg", plot=raw_distribution)

######################
## Graph down-regulated scores ##
######################
table = read.csv(wordsdown,sep='\t')
colnames(table) = c("V1","V2","V3")
table$V2 <- factor(table$V2, levels = table$V2[order(table$V3)])

graph_down = ggplot(table,aes(V2,V3))+
   geom_bar(stat="identity",position = "identity")+
   theme(axis.text.x = element_blank())+
   xlab("drugs") +
   ylab("score")

ggsave(filename="down_regulated.jpg", plot=graph_down)
