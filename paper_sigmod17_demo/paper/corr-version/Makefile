REPORT=corr_main
LATEX=pdflatex
BIBTEX=bibtex

SRCS=$(wildcard *.tex)
REFS=$(wildcard *.bib)
FIGS=$(wildcard Figures/*)

$(REPORT).pdf: $(SRCS) $(REFS) $(FIGS) 
	$(LATEX) $(REPORT)
	$(BIBTEX) $(REPORT)
	$(LATEX) $(REPORT)
	$(LATEX) $(REPORT)


force: $(SRCS) $(REFS) $(FIGS) 
	$(LATEX) $(REPORT)

bibs: $(SRCS) $(REFS)
	$(BIBTEX) $(REPORT)

full: $(SRCS) $(REFS) $(FIGS) 
	$(LATEX) $(REPORT)
	$(BIBTEX) $(REPORT)
	$(LATEX) $(REPORT)
	$(LATEX) $(REPORT)

pdf: $(REPORT).pdf

count: response.txt
	grep -Ev "^#" $^ | wc -c

clean:
	rm -f *.dvi *.aux *.log *.blg *.bbl *~ $(REPORT).ps $(REPORT).pdf
