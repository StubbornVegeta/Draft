# 将Markdown文件转换为HTML，并将生成的HTML文件放在指定路径下

# 定义pandoc选项
PANDOC_OPTIONS=--embed-resources -c pandoc.css --include-before-body=navbar.html --toc --lua-filter=toc-css.lua --standalone 

# 指定输出目录
OUTPUT_DIR=site

style_changed=$(shell git diff --name-only | grep -E "\.css|\.lua|navbar\.html" | wc -l)

# GEN_EASTER_EGG=$(shell )

ifeq ($(style_changed), 0)
# 找到所有有更改的Markdown文件，包括新增文件
MARKDOWN_FILES=$(shell git diff --name-only --diff-filter=ACMRTUXB HEAD | grep md)
# 将Markdown文件路径替换为HTML文件路径，并设置输出目录
HTML_FILES=$(patsubst %.md,$(OUTPUT_DIR)/%.html,$(MARKDOWN_FILES))
# 默认目标：生成所有HTML文件
all: $(HTML_FILES) copy

copy:
	cp -r easter-egg $(OUTPUT_DIR)

# 生成HTML文件
$(OUTPUT_DIR)/%.html: %.md
	mkdir -p $(dir $@)
	pandoc --embed-resources -c pandoc.css --include-before-body=navbar.html --toc --lua-filter=toc-css.lua --standalone --metadata toc-title=$(shell basename $(dir $<)) $< -o $(dir $@)/index.html
	# nohup google-chrome-stable $(dir $@)/index.html >/dev/null 2>&1 &

$(OUTPUT_DIR)/README.html: README.md
	mkdir -p $(OUTPUT_DIR)
	pandoc --embed-resources -c pandoc.css --include-before-body=navbar.html --toc --lua-filter=toc-css.lua --standalone --metadata toc-title="Draft" $< -o $(dir $@)/index.html
	# nohup google-chrome-stable $(dir $@)/index.html >/dev/null 2>&1 &

else

# 找到所有Markdown文件
ALL_MARKDOWN_FILES=$(shell find . -name '*.md')
ALL_HTML_FILES=$(patsubst %.md,$(OUTPUT_DIR)/%.html,$(ALL_MARKDOWN_FILES))

all: $(ALL_HTML_FILES) copy

copy:
	cp -r easter-egg $(OUTPUT_DIR)

$(OUTPUT_DIR)/%.html: %.md
	mkdir -p $(dir $@)
	pandoc --embed-resources -c pandoc.css --include-before-body=navbar.html --toc --lua-filter=toc-css.lua --standalone --metadata toc-title=$(shell basename $(dir $<)) $< -o $(dir $@)/index.html
	# nohup google-chrome-stable $(dir $@)/index.html >/dev/null 2>&1 &

$(OUTPUT_DIR)/./README.html: README.md
	mkdir -p $(OUTPUT_DIR)
	pandoc --embed-resources -c pandoc.css --include-before-body=navbar.html --toc --lua-filter=toc-css.lua --standalone --metadata toc-title="Draft" $< -o $(dir $@)/index.html
	# nohup google-chrome-stable $(dir $@)/index.html >/dev/null 2>&1 &

endif

# 删除所有HTML文件
clean:
	rm -rf $(OUTPUT_DIR)

