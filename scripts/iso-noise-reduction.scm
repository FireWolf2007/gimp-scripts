; Volf Alexander
; https://www.wolf-a.ru/
; GNU GPLv2

(define (ISONoiseReduction InImage InLayer InType InOpacity InRadius InFlatten)
    (let*    (
        (NoiseLayer (car (gimp-layer-copy InLayer TRUE)))
        (TempLayer (car (gimp-layer-copy InLayer TRUE)))
        (InDelta (* InRadius 7 ))
        (RadiusRB (* InRadius 1.5))
        (DeltaRB (* InDelta 2))
        )
;
        (gimp-image-add-layer InImage NoiseLayer -1)
        (gimp-image-add-layer InImage TempLayer -1)
;
; Find edges, Radius = 10, Warpmode = Smear (1), Edgemode = Laplace (5)
;
        (plug-in-edge TRUE InImage TempLayer 10 1 5)
        (gimp-desaturate TempLayer)
        (gimp-invert TempLayer)
        (plug-in-gauss TRUE InImage TempLayer 10.0 10.0 0)
        (gimp-selection-all InImage)
        (gimp-edit-copy TempLayer)
        (gimp-image-remove-layer InImage TempLayer)
;
        (let*    (
            (NoiseLayerMask (car (gimp-layer-create-mask NoiseLayer ADD-SELECTION-MASK)))
            )
            (gimp-image-add-layer-mask InImage NoiseLayer NoiseLayerMask)
            (gimp-floating-sel-anchor (car (gimp-edit-paste NoiseLayerMask FALSE)))
            (gimp-selection-none InImage)
;
; Select method
;
            (cond
;
; Blur seperate RGB channels, use different radius/delta for Red/Blue and Green
;
                ((= InType 0)
                    (begin
                        (gimp-image-set-component-active InImage RED-CHANNEL TRUE)
                        (gimp-image-set-component-active InImage GREEN-CHANNEL FALSE)
                        (gimp-image-set-component-active InImage BLUE-CHANNEL FALSE)
                        (plug-in-sel-gauss TRUE InImage NoiseLayer RadiusRB DeltaRB)
;
                        (gimp-image-set-component-active InImage RED-CHANNEL FALSE)
                        (gimp-image-set-component-active InImage GREEN-CHANNEL TRUE)
                        (plug-in-sel-gauss TRUE InImage NoiseLayer InRadius InDelta)
;
                        (gimp-image-set-component-active InImage GREEN-CHANNEL FALSE)
                        (gimp-image-set-component-active InImage BLUE-CHANNEL TRUE)
                        (plug-in-sel-gauss TRUE InImage NoiseLayer RadiusRB DeltaRB)
;
                        (gimp-image-set-component-active InImage RED-CHANNEL TRUE)
                        (gimp-image-set-component-active InImage GREEN-CHANNEL TRUE)
                    )
                )
;
; Blur luminance channel
;
                ((= InType 1)
                    (begin
                        (let*    (
                            (OrigLayer (cadr (gimp-image-get-layers InImage)))
                            (LABImage (car (plug-in-decompose TRUE InImage InLayer "LAB" TRUE)))
                               (LABLayer (cadr (gimp-image-get-layers LABImage)))
                               (LLayer (car (gimp-layer-copy InLayer TRUE)))
                               )
;
                               (gimp-image-add-layer InImage LLayer -1)
                               (gimp-selection-all LABImage)
                               (gimp-edit-copy (aref LABLayer 0))
                               (gimp-floating-sel-anchor (car (gimp-edit-paste LLayer FALSE)))
                               (plug-in-sel-gauss TRUE InImage LLayer RadiusRB DeltaRB)
                               (gimp-selection-all InImage)
                               (gimp-edit-copy LLayer)
                               (gimp-image-remove-layer InImage LLayer)
                               (gimp-floating-sel-anchor (car (gimp-edit-paste (aref LABLayer 0) FALSE)))
                               (let*    (
                                   (CompImage (car (plug-in-drawable-compose TRUE LABImage (aref LABLayer 0) (aref LABLayer 1) (aref LABLayer 2) 0 "LAB")))
                                   (CompLayer (cadr (gimp-image-get-layers CompImage)))
                                   )
                                   (gimp-selection-all CompImage)
                                   (gimp-edit-copy (aref CompLayer 0))
                                   (gimp-floating-sel-anchor (car (gimp-edit-paste NoiseLayer FALSE)))
                                   (gimp-image-delete CompImage)
                               )
                               (gimp-image-delete LABImage)
                        )
                       )
                )
;
; GMIP despeckle plugin
;
                ((= InType 2) (plug-in-despeckle TRUE InImage NoiseLayer InRadius 1 7 248))
            )
            (gimp-layer-set-opacity NoiseLayer InOpacity)
        )
;
; Flatten the image, if we need to
;
        (cond
            ((= InFlatten TRUE) (gimp-image-merge-down InImage NoiseLayer CLIP-TO-IMAGE))
            ((= InFlatten FALSE) (gimp-drawable-set-name NoiseLayer "Noisefree"))
        )
    )
)
;
;    SF-OPTION     "Noise Reduction Method"
;            '(
;                        "RGB channel blurring (faster)"
;                        "Luminance channel blurring (slower)"
;                        "GMIP Despeckle plugin"
;            )
;    SF-ADJUSTMENT    "Layer Opacity"    '(70.0 1.0 100.0 1.0 0 2 0)
;    SF-ADJUSTMENT    "Strength of Blurring"    '(5 1.0 10.0 0.5 0 2 0)
;    SF-TOGGLE    "Flatten Image"    FALSE
;
(define (duplicate-layer image layer)
	(let* ((dup-layer (car (gimp-layer-copy layer 1))))
              (gimp-image-add-layer image dup-layer 0)
	      dup-layer))

(define (batch-reduceisonoise-jpgs)
	(let* 
		(
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
				(ISONoiseReduction image drawable 1 60.0 4 TRUE)
				;(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
				(file-jpeg-save RUN-NONINTERACTIVE image drawable filename filename 1 0 0 0 "Photographer Volf Alexander; gimp@wolf-a.ru" 2 1 0 1)
				(gimp-image-delete image)
			)
			(set! filelist (cdr filelist))
		)
	)
)

