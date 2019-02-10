my_connectivity_score = function (experiment_drug, disease_query)
{
	up_in_disease <- which(disease_query == 1)
	down_in_disease <- which(disease_query == -1)  

	changed_by_compound <- c(head(experiment_drug,n=200), tail(experiment_drug,n=200)) # (up,down)
	X_up_in_disease <- merge(up_in_disease, changed_by_compound, by=0, by.x=0, by.y=0)
	X_down_in_disease <- merge(down_in_disease, changed_by_compound, by=0, by.x=0, by.y=0)

	X_up_sum <- sum(X_up_in_disease[,2], na.rm=TRUE)
	X_down_sum <- sum(X_down_in_disease[,2], na.rm=TRUE)
	
	X_Sum <- X_up_sum - X_down_sum	
	X_Sum
}
