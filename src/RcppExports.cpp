// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// MFDFA
List MFDFA(const NumericVector tsx, const IntegerVector scale, const int m, const NumericVector q);
RcppExport SEXP _RespirAnalyzer_MFDFA(SEXP tsxSEXP, SEXP scaleSEXP, SEXP mSEXP, SEXP qSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const NumericVector >::type tsx(tsxSEXP);
    Rcpp::traits::input_parameter< const IntegerVector >::type scale(scaleSEXP);
    Rcpp::traits::input_parameter< const int >::type m(mSEXP);
    Rcpp::traits::input_parameter< const NumericVector >::type q(qSEXP);
    rcpp_result_gen = Rcpp::wrap(MFDFA(tsx, scale, m, q));
    return rcpp_result_gen;
END_RCPP
}
// Mse
void Mse(String cmdstrp);
RcppExport SEXP _RespirAnalyzer_Mse(SEXP cmdstrpSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< String >::type cmdstrp(cmdstrpSEXP);
    Mse(cmdstrp);
    return R_NilValue;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_RespirAnalyzer_MFDFA", (DL_FUNC) &_RespirAnalyzer_MFDFA, 4},
    {"_RespirAnalyzer_Mse", (DL_FUNC) &_RespirAnalyzer_Mse, 1},
    {NULL, NULL, 0}
};

RcppExport void R_init_RespirAnalyzer(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
