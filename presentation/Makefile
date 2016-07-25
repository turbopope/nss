presentation.pdf: presentation.tex modelofdoom.tex ../bibliography/bibliography.bib
	pdflatex presentation
	bibtex presentation
	pdflatex presentation
	pdflatex presentation

clean:
	rm -f *.aux *.bbl *.blg *.lof *.log *.out *.toc *.lol *.nav *.snm *.bbl *.blg

realclean: clean
	rm -f presentation.pdf

.PHONY: clean
