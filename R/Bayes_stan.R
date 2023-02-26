
Bayes_stan = function(process = "Wiener",
                      type = "classical"){
  if(type == "classical"){
    if(process == "Wiener"){
      stan_code = "data {
                            int<lower=0> I;
                            int<lower=0> J;
                            matrix[I,J] x;
                            matrix[I,J] t;
                        }

                   parameters {
                            real mu;
                            real<lower=0> w;
                              }

                   model {
                          w ~ gamma(1,1);
                          mu ~ normal(0, 100/w);
                          for (i in 1:I){
                            for (j in 1:J) {
                              x[i,j] ~ normal(mu * t[i,j], w * t[i,j]);
                            }
                          }
                        }
                      "
    }else if(process == "Gamma"){
      stan_code = "data {
                        int<lower=0> I;
                        int<lower=0> J;
                        matrix[I,J] x;
                        matrix[I,J] t;
                      }

                 parameters {
                        real mu;
                        real<lower=0> w;
                      }

                 model {
                        w ~ gamma(1,1);
                        mu ~ normal(0, 100/w);
                        for (i in 1:I){
                          for (j in 1:J) {
                            x[i,j] ~ gamma(mu * t[i,j], 1/w);
                          }
                        }
                       }
        "
    }else if(process == "IG"){
      stan_code = "
              functions {
                          real IG_log (real x, real mu, real lambda){
                            // vector [num_elements (x)] prob;
                            real lprob;
                            lprob = log((lambda/(2*pi()*(x^3)))^0.5 * exp(-lambda*(x - mu)^2/(2*mu^2*x)));
                            return lprob;
                          }
              }

              data {
                int<lower=0> I;
                int<lower=0> J;
                matrix[I,J] x;
                matrix[I,J] t;
              }

              parameters {
                real mu;
                real<lower=0> w;
              }

              model {
                w ~ gamma(1,1); //scale
                mu ~ normal(0, 1); //shape
                for (i in 1:I){
                  for (j in 1:J) {
                    x[i,j] ~ IG_log (mu * t[i,j], w * t[i,j]^2);
                  }
                }
              }
"
    }
  }else if(type == "acc"){
    if(process == "Wiener"){
      stan_code = "
data {
  int<lower=0> I;
  int<lower=0> J;
  int<lower=0> K;
  real x[I,J,K];
  real t[I,J,K];
  vector[K] rels;
}

parameters {
  real a;
  real b;
  real<lower=0> sigma;
}

transformed parameters {
  vector[K] mu;
  mu = exp(a + b * rels);
}

model {
  sigma ~ gamma(1,1);
  a ~ normal(1,100);
  b ~ normal(1,100);
  for(k in 1:K){
    for (i in 1:I){
      for (j in 1:J) {
        x[i,j,k] ~ normal(mu[k] * t[i,j,k], sqrt(sigma^2 * t[i,j,k]));
      }
    }
  }
}

"
    }else if(process == "Gamma"){
      stan_code = "
data {
  int<lower=0> I;
  int<lower=0> J;
  int<lower=0> K;
  real x[I,J,K];
  real t[I,J,K];
  vector[K] rels;
}

parameters {
  real a;
  real b;
  real<lower=0> sigma;
}

transformed parameters {
  vector[K] mu;
  mu = exp(a + b * rels);
}

model {
  sigma ~ gamma(1,1);
  a ~ normal(1,100);
  b ~ normal(1,100);
  for(k in 1:K){
    for (i in 1:I){
      for (j in 1:J) {
        x[i,j,k] ~ gamma(mu[k] * t[i,j,k], 1/sigma);
      }
    }
  }
}
        "
    }else if(process == "IG"){
      stan_code = "
functions {
   real IG_log (real x, real mu, real lambda){
   // vector [num_elements (x)] prob;
   real lprob;
   lprob = log((lambda/(2*pi()*(x^3)))^0.5 * exp(-lambda*(x - mu)^2/(2*mu^2*x)));
   return lprob;
  }
}

data {
  int<lower=0> I;
  int<lower=0> J;
  int<lower=0> K;
  real x[I,J,K];
  real t[I,J,K];
  vector[K] rels;
}

parameters {
  real a;
  real b;
  real<lower=0> sigma;
}

transformed parameters {
  vector[K] mu;
  mu = exp(a + b * rels);
}

model {
  sigma ~ gamma(1,1);
  a ~ normal(1,100);
  b ~ normal(1,100);
  for(k in 1:K){
    for (i in 1:I){
      for (j in 1:J) {
        x[i,j,k] ~ IG_log (mu[k] * t[i,j,k], sigma * t[i,j,k]^2);
      }
    }
  }
}
"
    }

  }
  return(stan_code)
}
