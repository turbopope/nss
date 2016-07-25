presentation.pdf: presentation.tex
	pdflatex presentation
	pdflatex presentation

clean:
	rm -f *.aux *.bbl *.blg *.lof *.log *.out *.toc *.lol *.nav *.snm

realclean: clean
	rm -f presentation.pdf

.PHONY: clean
