# make all: data -> numbers and figures -> paper, report and slides.
# Change the input or a template and run it again.

all: paper report slides

data/penguins.csv:
	Rscript analysis/get-data.R

results/numbers.json: data/penguins.csv analysis/analysis.R
	Rscript analysis/analysis.R

paper: results/numbers.json
	quarto render content/paper.qmd

report: results/numbers.json
	quarto render content/report.qmd

slides: results/numbers.json
	quarto render content/slides.qmd

clean:
	rm -rf documents results

.PHONY: all paper report slides clean
