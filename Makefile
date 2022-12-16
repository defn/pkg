test:
	direnv allow
	nix develop --command ./validate

reset:
	for a in {x86_64,aarch64}-{linux,darwin}; do perl -pe "s{(sha256-...)}{sha256-aaa} if m{# $$a}" -i flake.nix; done

sha:
	for a in {x86_64,aarch64}-{linux,darwin}; do echo $$a $$(nix build ".#$$a" 2>&1 | grep got: | awk '{print $$2}') & done \
		| while read -r system sha; do if test -n "$$sha"; then perl -pe "s{(sha256-[^\"]+)}{$$sha} if m{# $$system}" -i flake.nix; fi; done
	$(MAKE) test

release:
	 git tag $$(cat VERSION ); git push origin $$(cat VERSION )

version:
	echo -n $(shell basename $(shell pwd))-$(version) > VERSION
	if test -f VENDOR; then echo -n $(version) > VENDOR; fi