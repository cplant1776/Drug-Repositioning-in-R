my_ks.test <- function (x, y)
{
    n.x <- length(x)
    n.y <- length(y)
    w <- c(x, y)
    z <- cumsum(ifelse(order(w) <= n.x, 1/n.x, -1/n.y))

    ifelse(max(z)<(-min(z)), max(abs(z)), -(max(abs(z))))
}

my_connectivity_score = function (experiment, query)
{
  rank.matrix <- length(experiment) - rank(experiment) + 1
  sets.up <- which(query == 1)
  sets.down <- which(query == -1)  

  ks_up <- ifelse(length(sets.up)>0, my_ks.test(seq_along(rank.matrix), rank.matrix[sets.up]), 0)
  ks_down <- ifelse(length(sets.down)>0, my_ks.test(seq_along(rank.matrix), rank.matrix[sets.down]), 0)
  raw.score <- ifelse( sign( ks_up ) == sign( ks_down ), 0, ks_up - ks_down )

  raw.score
}
