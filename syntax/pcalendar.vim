syntax match Year /[12][0-9][0-9][0-9]/
syntax match RegularDate /[ 0-9][0-9] /
syntax match LinkedDate /[ 0-9][0-9]_/ contains=CalendarSymbol
syntax match EmphDate /[ 0-9][0-9]@/  contains=CalendarSymbol
syntax match FootnoteDate /[ 0-9][0-9][*+]/ contains=FootnoteSymbol
syntax match CalendarSymbol /[@_]/
syntax match FootnoteSymbol /[+*/]/

hi clear Year 
hi clear FootnoteSymbol
hi link RegularDate Number
hi link FootnoteDate Number
hi link LinkedDate Underlined
hi link EmphDate SpellCap
hi link CalendarSymbol Ignore
