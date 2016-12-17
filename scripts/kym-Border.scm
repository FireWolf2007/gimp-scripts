; Volf Alexander
; https://www.wolf-a.ru/
; GNU GPLv2

(define (script-fu-kym-Link-Border2 InImage InLayer InOuterTotalWidth 
 InOuterTotalHeight InExtBottomBorder InInnerSize InDistanceImage 
 InOuterSize InDistanceBorder InUseSysColors InLineColor InBorderColor 
 InFeather InFont InLeftText InLeftTextSize InCenterText InCenterTextSize 
 InRightText InRightTextSize InFlattenImage InWorkOnCopy)
;
; define variables
  (let*
    (
        (TheImage 0)
        (TheLayer 0)
        (TheWidth 0)
        (TheHeight 0)
        (inner-border-width 0)
        (inner-border-height 0)
        (total-border-width 0)
        (total-border-height 0)
        (outer-border-width 0)
        (outer-border-height 0)
        (image-width 0)
        (image-height 0)
        (TheBackupColor 0)
        (TheLineColor 0)
        (TheBorderColor 0)
        (LeftTextLayer 0)
        (LeftTextWidth 0)
        (LeftTextHeight 0)
        (CenterTextLayer 0)
        (CenterTextWidth 0)
        (CenterTextHeight 0)
        (RightTextLayer 0)
        (RightTextWidth 0)
        (RightTextHeight 0)
    )

        (if (= InWorkOnCopy TRUE)
                           (begin ; work on copy
                             (set! TheImage (car (gimp-image-duplicate InImage)))
                             (gimp-image-undo-disable TheImage)
                             (gimp-selection-none TheImage)
                           )
                           (begin ; work with original image
                             (set! TheImage InImage)
                             (gimp-image-undo-group-start TheImage)
                             (gimp-selection-all TheImage)
                           )
        )

        ; initial setting of variables
        (set! TheLayer (car (gimp-image-flatten TheImage)))
        (set! TheWidth (car (gimp-image-width TheImage)))
        (set! TheHeight (car (gimp-image-height TheImage)))
        (set! inner-border-width  InInnerSize)
        (set! inner-border-height inner-border-width)
        (set! outer-border-width  InOuterSize)
        (set! outer-border-height outer-border-width)
        (set! total-border-width  InOuterTotalWidth)
        (set! total-border-height InOuterTotalHeight)
        (set! image-width (+ TheWidth  (* 2 total-border-width)))
        (set! image-height (+ TheHeight (* 2 total-border-height)))

        (set! TheBackupColor (car (gimp-context-get-foreground)))

        (if (= InUseSysColors TRUE) ; use system colors
            (begin
              (set! TheLineColor (car (gimp-context-get-foreground) ))
              (set! TheBorderColor (car (gimp-context-get-background) ))
            )
            (begin
              (set! TheLineColor InLineColor )
              (set! TheBorderColor InBorderColor )
            )
        )

        (set! TheLayer ( car (gimp-layer-copy TheLayer TRUE)))
        (gimp-drawable-set-name TheLayer "With Border")
;
; Generate the border
;
        (gimp-image-resize TheImage image-width image-height total-border-width total-border-height)

        (if (> InExtBottomBorder 0 )
            (begin ; extend the bottom border
              (set! image-height (+ image-height InExtBottomBorder ))
              (gimp-image-resize TheImage image-width image-height 0 0 )
            )
        )
;
        (let*    (
            (BorderLayer (car (gimp-layer-new TheImage image-width image-height RGBA-IMAGE "TempLayer" 100 NORMAL-MODE)))
            )
            (gimp-image-add-layer TheImage BorderLayer -1)
            (gimp-edit-clear BorderLayer)
;
            (gimp-rect-select TheImage 0 0 image-width image-height CHANNEL-OP-REPLACE FALSE 0)
            (gimp-rect-select TheImage total-border-width total-border-height TheWidth TheHeight CHANNEL-OP-SUBTRACT FALSE 0)
            (gimp-palette-set-foreground TheBorderColor)
            (gimp-edit-fill BorderLayer FOREGROUND-FILL)
;

            (cond
                ((> outer-border-width 0)
                    (begin
;
; Make the outer border line
;
                        (gimp-rect-select TheImage InDistanceBorder
                                                    InDistanceBorder
                                        (- image-width  (* InDistanceBorder 2))
                                        (- image-height (* InDistanceBorder 2))
                                        CHANNEL-OP-REPLACE InFeather (* 1.2 outer-border-width)
                        )
                        (gimp-rect-select TheImage total-border-width total-border-height TheWidth TheHeight CHANNEL-OP-SUBTRACT FALSE 0)
                        (gimp-palette-set-foreground TheLineColor)
                        (gimp-edit-fill BorderLayer FOREGROUND-FILL)

                        (gimp-rect-select TheImage (+ outer-border-width InDistanceBorder)
                                        (+ outer-border-height InDistanceBorder)
                                        (- image-width  (+ (* outer-border-width  2) (* InDistanceBorder 2)))
                                        (- image-height (+ (* outer-border-height 2) (* InDistanceBorder 2)))
                              CHANNEL-OP-REPLACE InFeather (* 1.2 outer-border-width)
                        )
                        (gimp-rect-select TheImage total-border-width total-border-height TheWidth TheHeight CHANNEL-OP-SUBTRACT FALSE 0)
                        (gimp-palette-set-foreground TheBorderColor)
                        (gimp-edit-fill BorderLayer FOREGROUND-FILL)
                    )
                )
            )
;
; Make the inner border line
;
            (cond
                ((> InInnerSize 0)
                    (begin
                        (gimp-rect-select TheImage (- total-border-width (+ inner-border-width InDistanceImage))
                                       (- total-border-height (+ inner-border-height InDistanceImage))
                                       (- image-width  (- (* total-border-width 2) (* (+ inner-border-width InDistanceImage) 2)) )
                                       (- (- image-height (- (* total-border-height 2) (* (+ inner-border-width InDistanceImage) 2)) ) InExtBottomBorder )
                              CHANNEL-OP-REPLACE InFeather (* 1.2 inner-border-width)
                        )
                        (gimp-rect-select TheImage total-border-width total-border-height TheWidth TheHeight CHANNEL-OP-SUBTRACT FALSE 0)
                        (gimp-palette-set-foreground TheLineColor)
                        (gimp-edit-fill BorderLayer FOREGROUND-FILL)

                        (if (> InDistanceImage 0)
                            (begin
                                (gimp-rect-select TheImage (- total-border-width InDistanceImage)
                                              (- total-border-height  InDistanceImage)
                                              (- image-width  (- (* total-border-width  2) (* InDistanceImage 2)))
                                              (- (- image-height (- (* total-border-height 2) (* InDistanceImage 2))) InExtBottomBorder)
                                      CHANNEL-OP-REPLACE InFeather (* 1.2 inner-border-width)
                                )
                                (gimp-rect-select TheImage total-border-width total-border-height TheWidth TheHeight CHANNEL-OP-SUBTRACT FALSE 0)
                                (gimp-palette-set-foreground TheBorderColor)
                                (gimp-edit-fill BorderLayer FOREGROUND-FILL)
                             )
                        )
                    )
                )
            )

            (gimp-image-merge-down TheImage BorderLayer CLIP-TO-IMAGE)
        )
;
        (gimp-selection-none TheImage)
;
; Add text if entered
;
; Left text
;
       (if (> (string-length InLeftText) 0)
           (begin
              (gimp-palette-set-foreground TheLineColor)
              (set! LeftTextLayer   ; render text in new layer
                (car
                  (gimp-text-fontname
                  TheImage -1
                  0 0
                  InLeftText
                  0
                  TRUE
                  InLeftTextSize PIXELS
                  InFont)
                  )
                )

                ; get rendered text size
                (set! LeftTextWidth   (car (gimp-drawable-width  LeftTextLayer) ) )
                (set! LeftTextHeight  (car (gimp-drawable-height LeftTextLayer) ) )

                ; move text to correct position
                (gimp-layer-resize LeftTextLayer LeftTextWidth LeftTextHeight 0 0 )
                (gimp-layer-set-offsets LeftTextLayer
                  total-border-width ; x
;                  ( + ( + ( + total-border-height TheHeight) 2 ) InInnerSize ); y - justify right
;                  ( - ( - ( - image-height 2 ) InInnerSize ) LeftTextHeight ); y - justify down
                  ( - ( - image-height ( / ( + total-border-height InExtBottomBorder ) 2 ) ) ( / LeftTextHeight 2 ) ) ; y - justify middle
                )
                (gimp-layer-resize-to-image-size LeftTextLayer )
           )
       )
;
; Center text
;
       (if (> (string-length InCenterText) 0)
           (begin
              (gimp-palette-set-foreground TheLineColor)
              (set! CenterTextLayer   ; render text in new layer
                (car
                  (gimp-text-fontname
                  TheImage -1
                  0 0
                  InCenterText
                  0
                  TRUE
                  InCenterTextSize PIXELS
                  InFont)
                  )
                )

                ; get rendered text size
                (set! CenterTextWidth   (car (gimp-drawable-width  CenterTextLayer) ) )
                (set! CenterTextHeight  (car (gimp-drawable-height CenterTextLayer) ) )

                ; move text to correct position
                (gimp-layer-resize CenterTextLayer CenterTextWidth CenterTextHeight 0 0 )
                (gimp-layer-set-offsets CenterTextLayer
                  ( - ( + total-border-width ( / TheWidth 2 ) ) ( / CenterTextWidth 2 ) ) ; x
;                  ( + ( + ( + total-border-height TheHeight) 2 ) InInnerSize ); y - justify right
;                  ( - ( - ( - image-height 2 ) InInnerSize ) CenterTextHeight ); y - justify down
                  ( - ( - image-height ( / ( + total-border-height InExtBottomBorder ) 2 ) ) ( / CenterTextHeight 2 ) ) ; y - justify middle
                )
                (gimp-layer-resize-to-image-size CenterTextLayer )
           )
       )
;
; Right text
;
       (if (> (string-length InRightText) 0)
           (begin
              (gimp-palette-set-foreground TheLineColor)
              (set! RightTextLayer   ; render text in new layer
                (car
                  (gimp-text-fontname
                  TheImage -1
                  0 0
                  InRightText
                  0
                  TRUE
                  InRightTextSize PIXELS
                  InFont)
                  )
                )

                ; get rendered text size
                (set! RightTextWidth   (car (gimp-drawable-width  RightTextLayer) ) )
                (set! RightTextHeight  (car (gimp-drawable-height RightTextLayer) ) )

                ; move text to correct position
                (gimp-layer-resize RightTextLayer RightTextWidth RightTextHeight 0 0 )
                (gimp-layer-set-offsets RightTextLayer
                  ( - ( - image-width total-border-width ) RightTextWidth ) ; x
;                  ( + ( + ( + total-border-height TheHeight) 2 ) InInnerSize ); y - justify right
;                  ( - ( - ( - image-height 2 ) InInnerSize ) RightTextHeight ); y - justify down
                  ( - ( - image-height ( / ( + total-border-height InExtBottomBorder ) 2 ) ) ( / RightTextHeight 2 ) ) ; y - justify middle
                )
                (gimp-layer-resize-to-image-size RightTextLayer )
           )
       )

       (if (= InFlattenImage TRUE)
           (begin
               (gimp-image-flatten TheImage)
           )
       )
;
; Finish work
;
        (if (= InWorkOnCopy TRUE)
            (begin  (gimp-image-clean-all TheImage)
                    (gimp-display-new TheImage)
                    (gimp-image-undo-enable TheImage)
            )
            (gimp-image-undo-group-end TheImage)
        )
    (gimp-palette-set-foreground TheBackupColor)
    )
    (gimp-displays-flush)
)

(define 
	(batch-all-jpgs-borderev )
	(let* 
		(
			(inColor 0)
			(pattern "*.[jJ][pP][gG]")
			(filelist (cadr (file-glob pattern 1)))
		)
		(while 
			(not (null? filelist))
			(let* 
				(
					(filename (car filelist))
					(image (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
					(drawable (car (gimp-image-get-active-layer image)))
				)
				(script-fu-kym-Link-Border2 image drawable 25 25 
                   0 1 0 0 1 FALSE '(0 0 0)
                   '(255 255 255) FALSE "Sans" 
                   "" 25 "Фотограф Елена Вольф" 25
                   "" 25 TRUE FALSE)
				(set! drawable (car (gimp-image-get-active-layer image)))
				(file-jpeg-save RUN-NONINTERACTIVE image drawable filename filename 1 0 0 0 "Photographer Volf Alexander; gimp@wolf-a.ru" 0 1 0 1)
				(gimp-image-delete image)
			)
           		(set! filelist (cdr filelist))
		)
	)
)
