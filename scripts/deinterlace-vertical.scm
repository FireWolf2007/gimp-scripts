; Volf Alexander
; https://www.wolf-a.ru/
; GNU GPLv2

(define (script-fu-deinterlace-vertical inImage inLayer inShift limitToggle)

    ; Определили переменные
    (let* (
        (theImage inImage)
        (theLayer inLayer)
        (floatLayer inLayer)
        (theShift inShift)
        (theHeight (car (gimp-drawable-height theLayer)))
        (theWidth (car (gimp-drawable-width theLayer)))
        (x 0)
        )
    (if (= limitToggle TRUE)
        (set! theWidth 500)
    )
    (gimp-selection-none theImage)
    (gimp-image-undo-group-start theImage)
    (while (< x theWidth)
        (gimp-rect-select theImage x 0 1 theHeight CHANNEL-OP-REPLACE 0 0)
        (gimp-edit-cut theLayer)
        (set! floatLayer (car (gimp-edit-paste theLayer FALSE)))
        (gimp-layer-set-offsets floatLayer x theShift)
        (gimp-floating-sel-anchor floatLayer)
        (set! x (+ x 2))
        (gimp-progress-update (/ x theWidth))
    );/while
    (gimp-image-undo-group-end theImage)
    (gimp-displays-flush)
  )
)

(script-fu-register "script-fu-deinterlace-vertical"
  _"_Deinterlace Vertical..."
  _"Deinterlace"
  "Volf Alexander"
  "2016, Volf Alexander, https://www.wolf-a.ru/"
  "5th December 2016"
  "RGB*"
  SF-IMAGE       "The Image"         0
  SF-DRAWABLE    "The Layer"         0
  SF-ADJUSTMENT _"Shift"            '(4 -10 10 1 1 0 0)
  SF-TOGGLE     _"Limit 500 pixels"        FALSE
)

(script-fu-menu-register "script-fu-deinterlace-vertical"
                         "<Image>/Filters/Deinterlace-Vertical")
