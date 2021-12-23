.PHONY: test

test : expected.txt results.txt
	diff -s expected.txt results.txt

PROGRAMS = one.awk two.awk
INPUTS = sample0.txt sample.txt sample2.txt input.txt

results.txt : $(PROGRAMS) $(INPUTS)
	./one.awk sample0.txt > $@
	./one.awk sample.txt > $@
	./one.awk sample2.txt > $@
	./one.awk input.txt >> $@
	./two.awk sample0.txt >> $@
	./two.awk sample.txt >> $@
	./two.awk sample2.txt >> $@
	./two.awk input.txt >> $@

clean:
	$(RM) results.txt
