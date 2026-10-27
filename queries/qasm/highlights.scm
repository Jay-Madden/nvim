((_) @comment @spell
 (#match? @comment "\\v^#.*$"))

((_) @keyword.directive
 (#match? @keyword.directive "\\v^\\.(align|assert|back|bit|byte|clone|code|const|double|else|elseif|endb|endf|endfor|endif|endloc|endm|endr|equ|float|foreach|func|global|if|ifset|include|int|lconst|local|long|lset|lunset|macro|rep|rodata|set|short|text|unset)$"))

((_) @function.builtin
 (#match? @function.builtin "\\v^(add|and|asr|bra|brr|clz|fadd|fmax|fmaxabs|fmin|fminabs|fmul|fsub|ftoi|itof|ldtmu0|ldtmu1|loadam|loadc|loadcv|ldcend|ldi|max|min|mov|mul24|nop|anop|mnop|or|read|ror|sacq|sbdone|sbwait|shl|shr|srel|sub|thrend|thrsw|v8adds|v8max|v8min|v8muld|v8subs|xor)(\\.[A-Za-z0-9]+)*$"))

((_) @function.macro
 (#match? @function.macro "\\v^(dma_h32|v32|vdw_setup_0|vdw_setup_1|vpm_setup)$"))

((_) @variable.builtin
 (#match? @variable.builtin "\\v^(elem_num|interrupt|r[0-5]|ra[0-9]+|rb[0-9]+|t0d|t0s|t1d|t1s|unif|vpm|vw_addr|vw_setup|vw_wait)$"))

((_) @label
 (#match? @label "\\v^:{1,2}[A-Za-z_][A-Za-z0-9_]*$"))
((_) @label
 (#match? @label "\\v^:{1,2}[0-9]+[fb]?$"))

((_) @constant
 (#match? @constant "\\v^[A-Z_][A-Z0-9_]*$"))

((_) @number
 (#match? @number "\\v^(0[xX][0-9A-Fa-f]+|[0-9]+)$"))

((_) @number.float
 (#match? @number.float "\\v^[0-9]+\\.[0-9]+$"))

((_) @string
 (#match? @string "\\v^\".*\"$"))

((_) @operator
 (#match? @operator "\\v^[+*/%^&=<>!-]+$"))

((_) @punctuation.delimiter
 (#match? @punctuation.delimiter "\\v^[,;:]$"))
