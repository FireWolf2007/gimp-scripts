; Volf Alexander
; https://www.wolf-a.ru/
; GNU GPLv2

(define 
	(set-copyright-ev2 InImage InText InFont InPercent InReserve InOpacity InColorPre InColor InPosition InBlur InFlatten)
	(let*    
		(
			(TheWidth (car (gimp-image-width InImage)))
			(TheHeight (car (gimp-image-height InImage)))
			(Old-FG-Color (car (gimp-palette-get-foreground)))
			(FontSize (/ (* TheHeight InPercent) 100))
			(BlurSize (* FontSize 0.07))
			(text-size (gimp-text-get-extents-fontname InText FontSize PIXELS InFont))
			(text-width (car text-size))
			(text-height (cadr text-size))
			(reserve-width (/ (* TheWidth (+ InReserve 1)) 100))
			(reserve-height (/ (* TheHeight InReserve) 100))
			(text-x 0)
			(text-y 0)
		)

		;Корректировка размера шрифта
		(if 
			(< TheWidth TheHeight) 
			(begin
       				(set! FontSize (/ (* TheWidth InPercent) 100))
				(set! BlurSize (* FontSize 0.07))
				(set! text-size (gimp-text-get-extents-fontname InText FontSize PIXELS InFont))
		        	(set! text-width (car text-size))
				(set! text-height (cadr text-size))
			)
		)
      (cond
        ((= InColorPre 0)
                  (gimp-palette-set-foreground '(0 0 0)))
        ((= InColorPre 240)
                  (gimp-palette-set-foreground '(240 240 240)))
        ((= InColorPre 255)
                  (gimp-palette-set-foreground '(255 255 255)))
        )
        (set! text-x (- TheWidth (+ text-width reserve-width)))
		(set! text-y (- TheHeight (+ text-height reserve-height)))
		(let*
			(
				(TextLayer 
					(car 
						(gimp-text-fontname InImage -1 text-x text-y InText -1 TRUE FontSize PIXELS InFont)
					)
				)
			)
			(gimp-layer-set-opacity TextLayer InOpacity)
			(gimp-context-set-foreground Old-FG-Color)
		)
	)
)
(define (script-fu-Eg-Copyright-ev2-all InImage InLayer InText InFont InPercent InOpacity InColor InPosition InBlur InFlatten)
    (set-copyright-ev2 InImage InText InFont InPercent 0 InOpacity 0 InColor InPosition InBlur InFlatten)
    (set-copyright-ev2 InImage InText InFont InPercent 0.02 InOpacity 255 InColor InPosition InBlur InFlatten)
)

(define (script-fu-Eg-Copyright-ev2 InImage InLayer InText InFont InPercent InOpacity InColor InPosition InBlur InFlatten)
    (gimp-image-undo-group-start InImage)
    (script-fu-Eg-Copyright-ev2-all InImage InLayer InText InFont InPercent InOpacity InColor InPosition InBlur InFlatten)
    (gimp-image-undo-group-end InImage)
    (gimp-displays-flush)
  )
;
; Register the function with the GIMP
;
(script-fu-register
    "script-fu-Eg-Copyright-ev2"
    "<Image>/FX-Foundry/Toolbox/Copyright www.wolf-a.ru"
    "Generate a copyright mark on an image. Best value if you adjust the defaults in the script file to your own needs."
    "Martin Egger (martin.egger@gmx.net)"
    "2006, Martin Egger, Bern, Switzerland"
    "12.04.2006"
    "RGB*,GRAY*"
    SF-IMAGE    "The Image"    0
    SF-DRAWABLE    "The Layer"    0
    SF-STRING     "Copyright" "www.wolf-a.ru"
    SF-FONT     "Font" "Iris"
    SF-ADJUSTMENT     "Text Height (Percent of image height)" '(6 1.0 100 1.0 0 2 0)
    SF-ADJUSTMENT    "Layer Opacity" '(100.0 1.0 100.0 1.0 0 0 0)
    SF-COLOR     "Copyright color (selection)" '(220 220 220)
    SF-OPTION     "Copyright position" '("Bottom right"
                "Bottom left"
                "Bottom center"
                "Top right"
                "Top left"
                "Top center"
                "Image center")
    SF-TOGGLE     "Blur copyright" FALSE
    SF-TOGGLE    "Flatten Image"    FALSE
)
;