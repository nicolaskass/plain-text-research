# Plain-text research

One piece of content, written once in plain text, becomes a journal-style paper, a
technical report and a slide deck. Every number in the three documents is read from the
analysis output; none is typed by hand.

This is the companion example to a series of posts on plain-text workflows for people in
the natural sciences, where most theses, papers and reports are still written in a word
processor.

## The idea in one picture

```
input                 steps                          result
─────                 ─────                          ──────
data/penguins.csv ──► analysis/analysis.R ──► results/numbers.json
                                              results/figures/*.png
                                                       │
content/_body.qmd ──► paper.qmd   (2 columns) ──► documents/content/paper.pdf
  text, citations     report.qmd  (cover, TOC) ──► documents/content/report.pdf
                      slides.qmd  (reveal.js)  ──► documents/content/slides.html
```

The content lives in one file. Each format is a short header that says how to lay it out.
Changing a journal's style means changing a header, never the text. Changing the data
means running `make` again: the paper, the report and the slides update together.

## Run it

Requirements: R (with `palmerpenguins`, `ggplot2`, `jsonlite`, `knitr`, `rmarkdown`) and
[Quarto](https://quarto.org) 1.4 or later, which brings Typst for the PDFs.

```bash
make all      # data → numbers and figures → paper, report, slides
make clean    # remove everything generated
```

The generated `results/` and `documents/` are committed, so the outputs can be compared
with what a fresh run produces.

## Layout

| Path | Role |
|---|---|
| `data/penguins.csv` | Input, as plain text |
| `analysis/get-data.R` | Exports the dataset from the R package, once |
| `analysis/analysis.R` | Writes every reported number to `results/numbers.json`, and the figures |
| `content/_body.qmd` | The content: text, inline numbers, figure references, citations |
| `content/paper.qmd`, `report.qmd`, `slides.qmd` | One header per output format |
| `content/references.bib` | Bibliography |
| `Makefile` | The steps, in order |

## Data

[palmerpenguins](https://allisonhorst.github.io/palmerpenguins/): measurements of 344
Adélie, Chinstrap and Gentoo penguins from Palmer Station, Antarctica, collected by
Dr. Kristen Gorman with the Palmer Station Long Term Ecological Research Program.

- Gorman KB, Williams TD, Fraser WR (2014). Ecological sexual dimorphism and environmental
  variability within a community of Antarctic penguins (genus *Pygoscelis*). *PLoS ONE*
  9(3): e90081. https://doi.org/10.1371/journal.pone.0090081
- Horst AM, Hill AP, Gorman KB (2020). palmerpenguins: Palmer Archipelago (Antarctica)
  penguin data. https://doi.org/10.5281/zenodo.3960218

The dataset is used here as a teaching example. The analysis is deliberately small; the
workflow is the point.

## How this was built

Designed by Nicolás Kass (biologist, university lecturer since 2010). The code and
templates were written with Claude Code under his direction and review.

## Licence

Code and text: MIT. Data: CC0, as distributed by the palmerpenguins package.
