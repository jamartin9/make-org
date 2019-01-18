EMACS_PROG ?= emacs
EMACS_FLAGS ?= -Q --batch
EMACS_CMD := $(EMACS_PROG) $(EMACS_FLAGS)

ORG_FILES := $(wildcard *.org)
FILES :=
FILES += $(patsubst %.org, %.pdf, $(ORG_FILES)) # pdf
FILES += $(patsubst %.org, %.md, $(ORG_FILES)) # md
FILES += $(patsubst %.org, %-beamer.pdf, $(ORG_FILES)) # beamer
FILES += $(patsubst %.org, %.html, $(ORG_FILES)) # html
FILES += $(patsubst %.org, %.txt, $(ORG_FILES)) # ascii
FILES += $(patsubst %.org, %.ics, $(ORG_FILES)) # icalendar
FILES += $(patsubst %.org, %.man, $(ORG_FILES)) # man
FILES += $(patsubst %.org, %.texi, $(ORG_FILES)) # texinfo
FILES += $(patsubst %.org, %.odt, $(ORG_FILES)) # open document


.PHONY: all prune clean
all: $(FILES)

prune:
	rm -f *.nav *.tex *.toc *.snm *.log *.aux *.out *.vrb *.tex\~ *.md\~ *.txt\~ *.html\~ *.ics\~ *.texi\~ *.pdf\~ *.man\~

clean : prune
	rm -f *.pdf *.md *.html *.odt *.man *.ics *.texi *.txt

%.pdf : %.org
	$(EMACS_CMD) $< -f org-latex-export-to-pdf

%-beamer.pdf : %.org
	$(EMACS_CMD) $< -f org-beamer-export-as-latex --eval='(write-file "$@")'
	pdflatex $@

%.md : %.org
	$(EMACS_CMD) $< -f org-md-export-to-markdown

%.html : %.org
	$(EMACS_CMD) $< -f org-html-export-to-html

%.txt : %.org
	$(EMACS_CMD) $< -f org-ascii-export-to-ascii

%.ics : %.org
	$(EMACS_CMD) $< -f org-icalendar-export-to-ics

%.odt : %.org
	$(EMACS_CMD) $< -f org-odt-export-to-odt

%.man : %.org
	$(EMACS_CMD) $< --eval="(require 'ox-man)" -f org-man-export-to-man # org-man-export-to-pdf

%.texi : %.org
	$(EMACS_CMD) $< -f org-texinfo-export-to-texinfo # org-texinfo-export-to-info
