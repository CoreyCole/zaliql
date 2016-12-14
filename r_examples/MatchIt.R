require(MatchIt)
require(cem)
require(bnlearn)

m.out1 <- matchit(treat ~ age + educ + nodegree,
                  data = lalonde,
                  method = "nearest",
                  distance = "logit")
summary(m.out1)
