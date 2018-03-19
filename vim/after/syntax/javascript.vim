syntax match jsDomElemFuncs contained /\%(createElement\|lookupPrefix\|isDefaultNamespace\|lookupNamespaceURI\)\>/ nextgroup=jsParen skipwhite
syntax match jsDomElemFuncs contained /\%(isSameNode\|isEqualNode\|compareDocumentPosition\|contains\|childElementCount\)\>/ nextgroup=jsParen skipwhite
syntax match jsDomElemAttrs contained /\%(preventDefault\|stopPropagation\|stopImmediatePropagation\)\>/ nextgroup=jsParen skipwhite

syntax match jsDomElemAttrs contained /\%(parentElement\|dataset\|classList\|lastElementChild\|nextElementSibling\)\>/
syntax match jsDomElemAttrs contained /\%(previousElementSibling\|firstElementChild\|textContent\|baseURI\|getClientRects\)\>/
syntax match jsDomElemAttrs contained /\%(getBoundingClientRect\|insertAdjacentHTML\|setItem\|getItem\|readAsText\|target\)\>/
syntax match jsClassListFuncs      contained /\%(add\|remove\)\>/ nextgroup=jsParen skipwhite

syntax keyword jsGlobalObjects localStorage FileReader

syntax keyword jsHtmlEvents ondragenter ondrag ondragleave ondragstart ondragend onmousewheel onscroll oncopy onbeforeunload ondragover onpaste oncut onchange

syntax clear jsDotNotation
syntax match jsDotNotation      "\."he=e-1 nextgroup=jsPrototype,jsDomElemAttrs,jsDomElemFuncs,jsHtmlElemAttrs,jsHtmlElemFuncs
syntax match jsDotNotation      "\.style\."he=e-1,hs=s+1 nextgroup=jsCssStyles
syntax match jsDotNotation      "\.classList\."he=e-1,hs=s+1 nextgroup=jsClassListFuncs

syntax keyword jsCssStyles      contained rubyAlign speak markerMid textOverflow textOverlineMode borderBottomLeftRadius orphans strokeLinejoin dominantBaseline backgroundSize textLineThrough borderRadius textUnderlineWidth fontStyle textUnderline quotes textAnchor rubyPosition strokeDashoffset pageBreakAfter textRendering fillOpacity colorInterpolation strokeLinecap strokeMiterlimit vectorEffect textOverline backgroundClip fontVariant outlineOffset clipPath pointerEvents size strokeWidth boxSizing backgroundOrigin borderRightColor textOverlineWidth clipRule fontSize letterSpacing backgroundRepeatY rubyOverhang borderImageWidth textOverlineStyle alignmentBaseline pageBreakBefore strokeOpacity textLineThroughMode lineHeight borderImageOutset stopColor textUnderlineMode lightingColor baselineShift float borderTopLeftRadius enableBackground shapeRendering tabSize fontWeight src borderImageSource markerEnd stopOpacity floodColor boxShadow markerStart colorRendering resize fillRule strokeDasharray textUnderlineColor glyphOrientationHorizontal textLineThroughStyle borderImageSlice marker colorProfile lineBreak textUnderlineStyle stroke borderBottomRightRadius glyphOrientationVertical fontFamily fontStretch borderTopRightRadius borderImageRepeat mask textLineThroughWidth textOverlineColor page imageRendering color pageBreakInside backgroundRepeatX floodOpacity borderImage fontSizeAdjust unicodeRange font kerning overflowWrap fill textLineThroughColor colorInterpolationFilters

