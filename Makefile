PROJECT_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

OUTPUT_DIR := $(PROJECT_DIR)/build
SRC_DIR := $(PROJECT_DIR)/src

MAINFILE := letter

SOURCE_FILES = $(fd -t f -e text -e lco -e png $(SRC_DIR))

.PHONY: fmt fmt-nix default clean out-dir

default: out-dir $(OUTPUT_DIR)/$(MAINFILE).pdf

fmt: fmt-nix

fmt-nix:
	nixfmt $$(find ${PROJECT_DIR} -name '*.nix')

clean:
	rm -rf $(OUTPUT_DIR)

out-dir:
	@printf 'Creating output directory: $(OUTPUT_DIR)\n'
	mkdir -p $(OUTPUT_DIR)

$(OUTPUT_DIR)/$(MAINFILE).pdf: out-dir $(SOURCE_FILES)
	cd $(SRC_DIR) &&\
	latexmk -shell-escape -interaction=nonstopmode -halt-on-error -norc -jobname=$(MAINFILE) -output-directory=$(OUTPUT_DIR) -pdf
