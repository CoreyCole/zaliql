Q=@
all: paper.pdf abstr.txt

paper.pdf: $(wildcard *.tex) $(wildcard figs/*.tex) $(wildcard code/*) $(wildcard *.bib)
	@printf '\\gdef\\therev{%s}\n\\gdef\\thedate{%s}\n' `git rev-parse --short HEAD` "`git log -1 --format='%ci' HEAD`" > rev.tex
	$(Q)bin/latexrun --bibtex-args=-min-crossrefs=100 paper

abstr.txt: abstr.tex
	@cat $< | \
          sed -e 's/\\emph//g' | \
          sed -e 's/\\LaTeX/LaTeX/g' | \
          sed -e 's/{//g' | \
          sed -e 's/}//g' | \
		  sed -e /^[%].*/d | \
		  sed -e 's/~/ /g' | \
		  sed -e 's/\\Y/Y/g' | \
          fmt -w72 > $@

clean:
	rm -rf paper.pdf latex.out


.PHONY: abstr.txt clean

include Makefile.spell
