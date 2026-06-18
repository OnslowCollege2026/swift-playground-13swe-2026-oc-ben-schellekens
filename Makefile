run:
	swift run

reset:
	[ -f ./BHSJapaneseDept.db ] && rm ./BHSJapaneseDept.db

rr: reset run
