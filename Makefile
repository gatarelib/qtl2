all: vignettes data external_vignettes extdata
.PHONY: vignettes data external_vignettes extdata

# R_OPTS: --vanilla without --no-environ
R_OPTS=--no-save --no-restore --no-init-file --no-site-file

VIGNETTES = assets/vignettes/linreg_benchmarks.html assets/vignettes/hmm_benchmarks.html assets/vignettes/rqtl_diff.html assets/vignettes/version05_new.html assets/vignettes/input_files.html assets/vignettes/developer_guide.html assets/vignettes/user_guide.html assets/vignettes/do_diagnostics.html
vignettes: ${VIGNETTES}

assets/vignettes/linreg_benchmarks.html: assets/vignettes/linreg_benchmarks.Rmd
	R $(R_OPTS) -e "devtools::install_github('kbroman/qtl2scan@0.3-8')" # install version that had lapack code
	cd $(<D);R $(R_OPTS) -e "rmarkdown::render('$(<F)')"
	R $(R_OPTS) -e "devtools::install_github('rqtl/qtl2scan')" # re-install latest version

assets/vignettes/%.html: assets/vignettes/%.Rmd
	cd $(<D);R $(R_OPTS) -e "rmarkdown::render('$(<F)')"

assets/vignettes/do_diagnostics.html: assets/vignettes/do_diagnostics.Rmd
	cd $(<D);R $(R_OPTS) -e "rmarkdown::render('$(<F)')"

data: assets/sampledata/grav2/grav2.yaml assets/sampledata/iron/iron.yaml

assets/sampledata/grav2/grav2.yaml: assets/sampledata/scripts/grav2cross2.R
	cd $(<D);R CMD BATCH ${R_OPTS} grav2cross2.R

assets/sampledata/iron/iron.yaml: assets/sampledata/scripts/iron2cross2.R
	cd $(<D);R CMD BATCH ${R_OPTS} iron2cross2.R

EXTDATA = ../qtl2geno/inst/extdata/grav2.zip ../qtl2geno/inst/extdata/iron.zip
extdata: ${EXTDATA}

../qtl2geno/inst/extdata/grav2.zip: assets/sampledata/grav2/grav2.yaml
	cp $(<D)/$(@F) $@

../qtl2geno/inst/extdata/iron.zip: assets/sampledata/iron/iron.yaml
	cp $(<D)/$(@F) $@
