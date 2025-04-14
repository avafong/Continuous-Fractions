use context shared-gdrive("contfracs-context.arr", "1mr5nHB7DDdOffE_hiovBiEuuBsl_59Gh")
include shared-gdrive("contfracs-definitions.arr", "1fFz3TaWdZgIfNxSGVYx0UQz_GXOBIVsc")

provide:
  take, repeating-stream, threshold, fraction-stream, terminating-stream,
  repeating-stream-opt, threshold-opt, fraction-stream-opt, cf-phi, cf-phi-opt,
  cf-e, cf-e-opt, cf-pi-opt,
end

include my-gdrive("contfracs-common.arr")
# END HEADER
# DO NOT CHANGE ANYTHING ABOVE THIS LINE
#
# You may write implementation-specific tests (e.g., of helper functions) in this file.

#--------------------------------------------------------------------------------------------------
## Part 1: Streams

fun take<T>(s :: Stream<T>, n :: Number) -> List<T>:
  doc: "given a Stream, extracts its finite prefix of the specified size as a list"
  if n == 0:
    empty
  else:
    link(lz-first(s), take(lz-rest(s), n - 1))
  end
end

fun repeating-stream(alon :: List<Number>) -> Stream<Number>:
  doc: ```given a list, produces a stream that repeats the
       list over and over. Assume the given list is non-empty.```
  fun pattern-repeat(og-list :: List<Number>, trk-list :: List<Number>) -> Stream<Number>:
    doc: ```goes through an list using the tracking list 
         and outputs a repeating list of numbers as a stream```
    cases (List) trk-list:
        # once pattern-repeat reaches the end of the pattern, it should return the 
        # repeating stream of the original list
      | empty => repeating-stream(og-list) 
      | link(f,r) => lz-link(f, {(): pattern-repeat(og-list, r)})
    end
  end
  pattern-repeat(alon, alon)
end

fun fraction-stream(coeff :: Stream<Number>) -> Stream<Number>:
  doc: ```consumes a stream of coefficients and produces a corresponding 
       stream of approximations```
  first-term = lz-first(coeff)
  lz-link(
    first-term, 
    {(): lz-map(
        {(contfrac): first-term + (1 / contfrac)},
        fraction-stream(lz-rest(coeff)))})
end

fun threshold(approx :: Stream<Number>, thresh :: Number)-> Number:
  doc: ```When the absolute difference between a term in the stream of approximations 
       and the next term in that stream is below thresh, report the earlier term```
  first = lz-first(approx)
  next = lz-first(lz-rest(approx))
  if num-abs(first - next) < thresh:
    first
  else: 
    threshold(lz-rest(approx), thresh)
  end
end

rec cf-phi :: Stream<Number> = lz-link(1, {(): cf-phi})
rec cf-e :: Stream<Number> = 
  lz-link(2, {(): lz-link(1, {(): 
        fun e-pattern(n :: Number) -> Stream<Number>:
            doc: ```if given a starting value of 0, outputs the 
                 repeating pattern section of the coefficients for e```
            new-even-num = 2 + n
            lz-link(new-even-num, {(): lz-link(1, {(): lz-link(1, {(): e-pattern(new-even-num)})})})
          end
          e-pattern(0)})})

#------------------------------------------------------------------------------------------------
## Part 2: Options and Terminating Streams

fun terminating-stream(numbers :: List<Number>) -> Stream<Option<Number>>:
  doc: "converts a list of numbers into a corresponding stream of number options followed by nones"
  cases (List) numbers:
    | empty =>
      nones
    | link(f,r) => 
      lz-link(some(f), {(): terminating-stream(r)})
  end
end

fun repeating-stream-opt(numbers :: List<Number>) -> Stream<Option<Number>>:
  doc: ```given a list, produces a stream of options that repeats the
       list over and over. Assume the given list is non-empty.```
  fun pattern-repeat(og-list :: List<Number>, trk-list :: List<Number>) -> Stream<Option<Number>>:
    cases (List) trk-list:
      | empty => repeating-stream-opt(og-list) 
      | link(f,r) => lz-link(some(f), {(): pattern-repeat(og-list, r)})
    end
  end
  pattern-repeat(numbers, numbers)
end

fun fraction-stream-opt(coeff :: Stream<Option<Number>>)
  -> Stream<Option<Number>>:
  doc: ```consumes a stream of coefficients and produces a corresponding 
       stream of approximations represented by options``` 
  first-term = lz-first(coeff)
  cases (Option) first-term:
    | none => nones
    | some(_) => 
      lz-link(
        first-term, 
        {(): lz-map( 
            {(x): 
              cases (Option) x:
                | none => none ## if lz-map runs into a none in the stream, returns a none
                | some(_) => 
                  some(first-term.value + (1 / x.value))
              end}, 
            fraction-stream-opt(lz-rest(coeff)))}) 
  end
end

fun threshold-opt(approx :: Stream<Option<Number>>, 
    thresh :: Number) -> Number:
  doc: ```When the abs difference between a term in the stream of approx 
       and the next term in that stream is below thresh, report the earlier term as an Option. 
       If we run out of values before finding the approx, raises error```
  first = lz-first(approx)
  next = lz-first(lz-rest(approx))
  cases (Option) next:
    | none => raise("Threshold too small to approximate")
    | some(nxt-vl) => 
      first-vl = first.value
      if num-abs(first-vl - nxt-vl) < thresh:
        first-vl
      else: 
        threshold-opt(lz-rest(approx), thresh)
      end
  end
end

rec cf-phi-opt :: Stream<Option<Number>> = lz-link(some(1), {(): cf-phi-opt})
rec cf-e-opt :: Stream<Option<Number>> = 
  lz-link(some(2), {(): lz-link(some(1), {():
          fun e-pattern-opt(n :: Number) -> Stream<Option<Number>>:
            doc: ```if given a starting value of 0, outputs the 
                 repeating pattern section of the coefficients for e as Options```
            new-even-num = 2 + n 
            lz-link(some(new-even-num), 
              {(): lz-link(some(1), {(): lz-link(some(1), {(): e-pattern-opt(new-even-num)})})})
          end
          e-pattern-opt(0)})})

cf-pi-opt :: Stream<Option<Number>> = 
  lz-link(some(3), 
    {(): lz-link(some(7), 
        {(): lz-link(some(15), 
            {(): lz-link(some(1), 
                {():lz-link(some(292), 
                    {(): nones})})})})})