paper.pdf: paper.tex paper.bib Makefile
	pdflatex -shell-escape paper
	bibtex paper
	pdflatex -shell-escape paper
	pdflatex -shell-escape paper
	./checkwords

rebuild:
	make realclean
	make

clean:
	rm -f *~
	rm -f *.aux
	rm -f *.log
	rm -f *.toc
	rm -f *.blg
	rm -f *.bbl
	rm -f paper.ps
	rm -f *.out
	rm -f *.out
	rm -f *.bak
	rm -f *stackdump*

realclean: clean
	rm -f paper.pdf

.PHONY: clean realclean checkwords
