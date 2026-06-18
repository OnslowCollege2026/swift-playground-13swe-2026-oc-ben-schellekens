.PHONY: run

rr: reset run

run:
	swift run

reset:
	[ -f ./BHSJapaneseDept.db ] && rm ./BHSJapaneseDept.db
