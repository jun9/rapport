<!--head
Title: Generate beta distribution
Description: Random generation for the Beta distribution with parameters.
Author: Rapporter Team (@rapporter)
Packages: nortest
Data required: FALSE

n | *number[1,Inf]=100 | Observations | Number of observations
shape1 | *number[0,100]=0.1 | Alpha | First parameter of the Beta distribution
shape2 | *number[0,100]=0.1 | Beta | Second parameter of the Beta distribution
head-->
# Histogram

The below [histogram](http://en.wikipedia.org/wiki/Histogram) shows the graphical representation of the estimated probability distribution (generated by the provided parameters).

<%=
g <- rbeta(n, shape1, shape2)
set.caption(paste0('rbeta(n = ', n, ', shape1 = ', shape1, ', shape2 = ', shape2, ')'))
hist(g, main = '', xlab = '')
%>

The plot was generated with `hist` command, the grid was added automatically.

# Descriptives

The [skewness](http://en.wikipedia.org/wiki/Skewness) is <%=skewness(g)%> and the [kurtosis](http://en.wikipedia.org/wiki/Kurtosis) is <%=kurtosis(g)%> based on the <%=n%> observations, although most [frequentists](http://xkcd.com/1132/) would be rather interested in the [mean](http://xkcd.com/207/) (<%=mean(g)%>) and standard deviation (<%=sd(g)%>).

But did we generated a [normal distribution](http://en.wikipedia.org/wiki/Normal_distribution) after all?

# Normality check

Various hypothesis tests can be applied in order to test if the distribution of given random variable violates normality assumption. These procedures test the H~0~ that provided variable's distribution is _normal_. At this point only few such tests will be covered: the ones that are available in `stats` package (which comes bundled with default R installation) and `nortest` package that is [available](http://cran.r-project.org/web/packages/nortest/index.html) on CRAN.

 - **Shapiro-Wilk test** is a powerful normality test appropriate for small samples. In R, it's implemented in `shapiro.test` function available in `stats` package.
 - **Lilliefors test** is a modification of _Kolmogorov-Smirnov test_ appropriate for testing normality when parameters or normal distribution ($\mu$, $\sigma^2$) are not known. `lillie.test` function is located in `nortest` package.
 - **Anderson-Darling test** is one of the most powerful normality tests as it will detect the most of departures from normality. You can find `ad.test` function in `nortest` package.
 - **Pearson $\chi^2$ test** is another normality test which takes more "traditional" approach in normality testing. `pearson.test` is located in `nortest` package.

## Results

Here you can see the results of applied normality tests (_p-values_ less than 0.05 indicate significant discrepancies):

<%=
if (length(g) > 5000) {
    h <- htest(g, lillie.test, ad.test, pearson.test)
} else {
    h <- htest(g, shapiro.test, lillie.test, ad.test, pearson.test)
}
p <- .05
h
-%>

So, let's draw some conclusions based on applied normality test:

<% if (!is.na(h[1, 3])) { -%>
 - based on _Lilliefors test_, the distribution is <%= ifelse(h[1, 3] < p, "not normal", "normal") %>
<% } %>
<% if (!is.na(h[2, 3])) { -%>
 - _Anderson-Darling test_ confirms <%= ifelse(h[2, 3] < p, "violation of", "") %> normality assumption
<% } %>
<% if (!is.na(h[3, 3])) { -%>
 - _Pearson's $\chi^2$ test_ classifies the underlying distribution as <%= ifelse(h[3, 3] < p, "non-normal", "normal") %>
<% } %>
<% if (length(g) > 5000) { -%>
 - according to _Shapiro-Wilk test_, the distribution is <%= ifelse(h[4, 3] < p, "not", "") %> normal.
<% } %>

## Q-Q Plot

"Q" in _Q-Q plot_ stands for _quantile_, as this plot compares empirical and theoretical distribution (in this case, _normal_ distribution) by plotting their quantiles against each other. For normal distribution, plotted dots should approximate a "straight", `x = y` line.

<%=
set.caption('Q-Q plot')
qqmath(g, panel=function(x){
            panel.qqmath(x)
            panel.qqmathline(x, distribution = qnorm)
}, xlab = "Theoretical Quantiles", ylab = "Empirical Quantiles")
%>

## Kernel Density Plot

_Kernel density plot_ is a plot of smoothed _empirical distribution function_. As such, it provides good insight about the shape of the distribution. For normal distributions, it should resemble the well known "bell shape".

<%=
set.caption('Kernel Density Plot')
rp.densityplot(g)
%>

