; Volf Alexander
; https://www.wolf-a.ru/
; GNU GPLv2
;
; Define the function
;
(define (script-fu-Eg-Copyright-va InImage InLayer InText InFont InPercent InReserve InOpacity InColorPre InColor InPosition InBlur InFlatten)
;
; Save history
;
    (gimp-image-undo-group-start InImage)
;
    (let*    (
        (TheWidth (car (gimp-image-width InImage)))
        (TheHeight (car (gimp-image-height InImage)))
        (Old-FG-Color (car (gimp-palette-get-foreground)))
        (FontSize (/ (* TheHeight InPercent) 100))
        (BlurSize (* FontSize 0.07))
        (text-size (gimp-text-get-extents-fontname InText FontSize PIXELS InFont))
        (text-width (car text-size))
        (text-height (cadr text-size))
        (reserve-width (/ (* TheWidth (+ InReserve 4)) 100))
        (reserve-height (/ (* TheHeight InReserve) 100))
        (text-x 0)
        (text-y 0)
        )
;������������� ������� ������
(if (< TheWidth TheHeight) 
	(begin
       		(set! FontSize (/ (* TheWidth InPercent) 100))
		(set! BlurSize (* FontSize 0.07))
        (set! text-size (gimp-text-get-extents-fontname InText FontSize PIXELS InFont))
        (set! text-width (car text-size))
        (set! text-height (cadr text-size))
	)
)
;
; Generate copyright text on the image
;
; Select the text color
;
        (cond
;
; White
;
            ((= InColorPre 0) (gimp-palette-set-foreground '(240 240 240)))
;
; Gray
;
            ((= InColorPre 1) (gimp-palette-set-foreground '(127 127 127)))
;
; Black
;
            ((= InColorPre 2) (gimp-palette-set-foreground '(15 15 15)))
;
; Selection
;
            ((= InColorPre 3) (gimp-palette-set-foreground InColor))
        )
;
;    Select position
;
        (cond
;
;    Bottom right
;
            ((= InPosition 0)
                (begin
                    (set! text-x (- TheWidth (+ text-width reserve-width)))
                    (set! text-y (- TheHeight (+ text-height reserve-height)))
                )
            )
;
;    Bottom left
;
            ((= InPosition 1)
                (begin
                    (set! text-x reserve-width)
                    (set! text-y (- TheHeight (+ text-height reserve-height)))
                )
            )
;
;    Bottom center
;
            ((= InPosition 2)
                (begin
                    (set! text-x (/ (- TheWidth text-width) 2))
                    (set! text-y (- TheHeight (+ text-height reserve-height)))
                )
            )
;
;    Top right
;
            ((= InPosition 3)
                (begin
                    (set! text-x (- TheWidth (+ text-width reserve-width)))
                    (set! text-y reserve-height)
                )
            )
;
;    Top left
;
            ((= InPosition 4)
                (begin
                    (set! text-x reserve-width)
                    (set! text-y reserve-height)
                )
            )
;
;    Top center
;
            ((= InPosition 5)
                (begin
                    (set! text-x (/ (- TheWidth text-width) 2))
                    (set! text-y reserve-height)
                )
            )
;
;    Image center
;
            ((= InPosition 6)
                (begin
                    (set! text-x (/ (- TheWidth text-width) 2))
                    (set! text-y (/ (- TheHeight text-height) 2))
                )
            )
        )
;
        (let*    (
            (TextLayer (car (gimp-text-fontname InImage -1 text-x text-y InText -1 TRUE FontSize PIXELS InFont)))
            )
            (gimp-layer-set-opacity TextLayer InOpacity)
;
; Blur the text, if we need to
;
            (if (= InBlur TRUE) (plug-in-gauss TRUE InImage TextLayer BlurSize BlurSize 0))
;
; Flatten the image, if we need to
;
            (cond
                ((= InFlatten TRUE) (gimp-image-merge-down InImage TextLayer CLIP-TO-IMAGE))
                ((= InFlatten FALSE)
                    (begin
                        (gimp-drawable-set-name TextLayer "Copyright")
                        (gimp-image-set-active-layer InImage InLayer)
                    )
                )
            )
        )
        (gimp-context-set-foreground Old-FG-Color)
    )
;
; Finish work
;
    (gimp-image-undo-group-end InImage)
    (gimp-displays-flush)
;
)
;
; Register the function with the GIMP
;
(script-fu-register
    "script-fu-Eg-Copyright-va"
    "<Image>/FX-Foundry/Toolbox/Copyright Alexander Volf"
    "Generate a copyright mark on an image. Best value if you adjust the defaults in the script file to your own needs."
    "Martin Egger (martin.egger@gmx.net)"
    "2006, Martin Egger, Bern, Switzerland"
    "12.04.2006"
    "RGB*,GRAY*"
    SF-IMAGE    "The Image"    0
    SF-DRAWABLE    "The Layer"    0
    SF-STRING     "Copyright" "\302\251 Alexander Volf"
    SF-FONT     "Font" "Easy Street EPS Regular , Semi-Expanded"
    SF-ADJUSTMENT     "Text Height (Percent of image height)" '(10 1.0 100 1.0 0 2 0)
    SF-ADJUSTMENT    "Distance from border (Percent of image height)" '(3 0.0 10 1.0 0 2 0)
    SF-ADJUSTMENT    "Layer Opacity" '(50.0 1.0 100.0 1.0 0 2 0)
    SF-OPTION    "Copyright color (preset)" '("White"
                "Gray"
                "Black"
                "Color from selection")
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