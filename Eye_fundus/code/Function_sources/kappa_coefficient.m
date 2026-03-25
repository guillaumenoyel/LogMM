%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kappa coefficient
%
% [ kappa_coeff , Pobs_agrm , Pexp_agrm ] = kappa_coefficient( Ntab )
%
% KAPPA: This function computes the Cohen's kappa coefficient.
% Cohen's kappa coefficient is a statistical measure of inter-rater
% reliability. It is generally thought to be a more robust measure than
% simple percent agreement calculation since k takes into account the
% agreement occurring by chance.
% Kappa provides a measure of the degree to which two judges, A and B,
% concur in their respective sortings of N items into k mutually exclusive
% categories. A 'judge' in this context can be an individual human being, a
% set of individuals who sort the N items collectively, or some non-human
% agency, such as a computer program or diagnostic test, that performs a
% sorting on the basis of specified criteria.
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%INPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% Ntab = [TP FP
%         FN TN];          # Contingency table
%
%                           Reference segmentation
%                            Positive | Negative
%--------------------------------------------------        
% Estimated     : Positive      TP         FP
% Segmenttation : Negative      FN         TN
%
% TP : True  Positives
% FP : False Positives
% FN : False Negatives
% TN : True  Negatives
%
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%OUTPUTS%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
%
% kappa_coeff              # Kappa coefficient
% Pobs_agrm                # Relative observed agreement among raters
% Pexp_agrm                # Probability of chance agreement
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kappa_coefficient.m
% Guillaume NOYEL 12-09-2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ kappa_coeff , Pobs_agrm , Pexp_agrm ] = kappa_coefficient( Ntab )

% % Contingency table
% Ntab = [TP FP
%         FN TN];
 
% Ntab = [ 3 2
%          1 5];

n_i = sum(Ntab,2);% marginal line sum
n_j = sum(Ntab,1);% marginal column sum
Nobs = sum(Ntab(:));% totla effective

%Theoretical Frequencies of the contingencie table
F = n_i*n_j / Nobs;

% Relative observed agreement among raters
Pobs_agrm = sum(diag(Ntab))/ Nobs;%(TP+TN) / Nobs

% Probability of chance agreement%Relative expected agreement among raters
Pexp_agrm = sum(diag(F)) / Nobs;

% Kappa coeefficient
kappa_coeff = (Pobs_agrm-Pexp_agrm)/(1-Pexp_agrm);

end
