.PHONY: test

test : expected.txt results.txt
	diff -s expected.txt results.txt

PROGRAMS = one.awk two.awk
INPUTS = input.txt

results.txt : $(PROGRAMS) $(INPUTS)
	./one.awk input.txt > $@
	./two.awk input.txt >> $@

clean:
	$(RM) results.txt
