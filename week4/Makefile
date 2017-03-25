ARCHIVED := data/isles.lower.counts.tsv fig/isles.lower.counts.png \
	data/abyss.lower.counts.tsv fig/abyss.lower.counts.png \
	data/sierra.lower.counts.tsv fig/sierra.lower.counts.png

# Dummy targets
all: make-example-master/fig/sierra.lower.counts.png make-example-master/fig/isles.lower.counts.png make-example-master/fig/abyss.lower.counts.png make-example-master/zipf_results.tgz

clean:
	rm --force data/* fig/*

test: fig/test.lower.counts.png

testclean: 
	rm data/test* fig/test*

.PHONY: all clean test testclean

.SECONDARY: data/test.lower.counts.tsv

# Download data and bootstrap local setup
books/%.txt:
	curl https://codeload.github.com/bsmith89/make-example/tar.gz/master \
	> make-example-master.tgz
	tar -xzf make-example-master.tgz
	#mv Makefile make-example-master
	cd make-example-master; mkdir data/ fig/ scripts/; mv *.py scripts/

# Analysis and plotting
data/%.txt: books/%.txt
	cd make-example-master; cp $^ $@

data/%.lower.txt: data/%.txt
	cd make-example-master; tr '[:upper:]' '[:lower:]' < $^ > $@

data/%.counts.tsv: scripts/wordcount.py data/%.txt
	cd make-example-master; ./$^ $@

fig/%.counts.png: scripts/plotcount.py data/%.counts.tsv
	cd make-example-master; ./$^ $@

# Archive for sharing
zipf_results.tgz: ${ARCHIVED}
	cd make-example-master;\
	rm -rf zipf_results/; \
	mkdir zipf_results/; \
	cp $^ zipf_results/; \
	tar -czf $@ zipf_results/; \
	rm -r zipf_results/
