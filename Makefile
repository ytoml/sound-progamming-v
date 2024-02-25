fmt:
	v fmt -w .
fmt-check:
	v fmt -diff .
	v fmt -verify .
test:
	v test .