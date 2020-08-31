
default: clean build

bin:
	mkdir bin

/usr/local/bin/snykout: bin/snykout
	cp bin/snykout /usr/local/bin/snykout

install: /usr/local/bin/snykctl

bin/snykout: bin shard.lock
	crystal build src/compile.cr -o bin/snykout

build: bin/snykout

release:
	crystal build --release src/compile.cr -o bin/snykout

shard.lock: shard.yml
	shards update

fmt:
	crystal tool format

spec: test
test:
	crystal spec

lint: shard.lock
	./bin/ameba

lib/icr/bin/icr: shard.lock
	make -C lib/icr install

repl: lib/icr/bin/icr
	./lib/icr/bin/icr

clean:
	rm -f bin/snykout


.PHONY: install build release fmt test lint repl clean
