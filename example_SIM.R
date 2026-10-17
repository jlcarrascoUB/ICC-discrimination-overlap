# Reproducible numerical examples
# A Probabilistic Interpretation of the Intraclass Correlation Coefficient
# via Discrimination and Overlap
# Josep L. Carrasco
#
# Requirements: R, package cccrm (including the bpres dataset).
# This script reproduces the numerical calculations for the two examples
# in the article. It does not generate the article's figure (Plot1.pdf).
# Run the entire script in an R session with these packages installed.

library(cccrm)

# Expected pairwise discrimination (AUC) and overlap (OVL) under the
# one-way random-effects normal model; r = tau / sigma.
e_auc <- function(r) 0.5 + atan(r) / pi
e_ovl <- function(r) 1 - 2 * atan(r / sqrt(2)) / pi

# -----------------------------------------------------------------------------
# Scenario 1: Reliability (one measurement method)
# -----------------------------------------------------------------------------
# Select measurements from method 1 in the bpres dataset.
newdat <- subset(bpres, METODE == 1)

# Fit the variance-components model and obtain the ICC and its confidence limits.
icc_rel <- ccc_vc(newdat, "DIA", "ID")
print(icc_rel)
print(summary(icc_rel))

# Between-subject and within-subject standard deviations, respectively.
# The order of the variance components follows the ccc_vc() output.
tau <- sqrt(icc_rel$vc[1])
sigma <- sqrt(icc_rel$vc[2])
r <- as.numeric(tau / sigma)

cat("\nScenario 1: Reliability\n")
print(c(tau = tau, sigma = sigma, rSNR = r))
print(c(ICC = unname(icc_rel$ccc[1]),
        expected_AUC = e_auc(r),
        expected_OVL = e_ovl(r)))

# Transform the ICC confidence limits to the rSNR, AUC and OVL scales.
# ICC and expected AUC increase with rSNR; expected OVL decreases with rSNR.
# Here ccc[2:3] are assumed to contain the lower and upper ICC limits.
ci_icc <- icc_rel$ccc[c(2, 3)]
ci_rsnr <- sqrt(ci_icc / (1 - ci_icc))
ci_auc <- e_auc(ci_rsnr)
ci_ovl <- rev(e_ovl(ci_rsnr))

cat("\nScenario 1: Confidence intervals (lower, upper)\n")
print(rbind(ICC = unname(ci_icc),
            rSNR = unname(ci_rsnr),
            expected_AUC = unname(ci_auc),
            expected_OVL = unname(ci_ovl)), digits = 5)

# -----------------------------------------------------------------------------
# Scenario 2: Concordance (non-longitudinal method comparison)
# -----------------------------------------------------------------------------
# One measurement per subject and method; no subject-by-method interaction.
ccc_mc <- ccc_vc(bpres, "DIA", "ID", "METODE")
print(ccc_mc)
print(summary(ccc_mc))

# Between-subject variance component from the fitted model.
tau2 <- ccc_mc$vc[1]

# D2 = 100: squared tolerance value used in the article's illustration.
# p = 0.90: target coverage probability.
D2 <- 100
p <- 0.90

# ICC threshold corresponding to the chosen tolerance and coverage.
# Formula retained exactly as in the original analysis.
thr_icc <- function(tau2, D2, p) {
  (2 * qnorm((1 + p) * 0.5) * tau2) /
    (D2 + 2 * qnorm((1 + p) * 0.5) * tau2)
}

icc_threshold <- thr_icc(tau2, D2, p)
cat("\nScenario 2: Concordance\n")
print(c(between_subject_variance = unname(tau2),
        D2 = D2, target_coverage = p,
        ICC_threshold = unname(icc_threshold)))

# Test the estimated concordance coefficient against the specified threshold.
# See ?Ztest in cccrm for the test's hypotheses and reporting conventions.
print(Ztest(ccc_mc, r0 = icc_threshold, info = TRUE))

# For reproducibility, uncomment the following line to record package versions:
# sessionInfo()
