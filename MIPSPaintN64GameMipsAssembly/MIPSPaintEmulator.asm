// ---------------------------------------------------------------------------------------------------------------------------------
// N64 Game MIPS Paint by Emma Ruckle
// Emulator edition
// User can draw on the screen using the DPAD, toggle between erase (JOY_CUP), draw (JOY_CDOWN), and move modes (JOY_CRIGHT)
// User can select colors in the color palette (JOY_CLEFT)
// User enters game by pressing JOY_START while on title screen
// User can reread instructions (JOY_B) or restart (JOY_Z)
// ---------------------------------------------------------------------------------------------------------------------------------
arch n64.cpu
endian msb
output "MIPSPaintEmulator.N64", create
fill $00101000 // Set ROM Size

origin $00000000
base $80000000

// files in LIB folder are INC files written by PeterLemon on github
include "LIB/N64.INC"
include "LIB/N64_GFX.INC"
include "LIB/COLORS32.INC"
include "N64_Header.asm"
include "LIB/N64_INPUT.INC"
include "N64_GAMEPLAY_EMUL.INC"
include "N64_GAME_COLOR.INC"
include "N64_GAME_SPRITES.INC"
include "N64_FONT.INC"
include "N64_AUDIO.INC"
insert "LIB/N64_BOOTCODE.BIN"

constant fb1 = $A0100000 // game buffer
constant fb2 = $A0200000// start screen buffer

Start:
	// PeterLemon macros --------------------------------------------
	N64_INIT()
	ScreenNTSC(320, 240, BPP32, fb2)
	// ---------------------------------------------------------------
		TitleScreen()
		InitController(PIF1) // PeterLemon macro, initialize controller
	Restart:
	initFramebuffer(WHITE32, framebuffer, $A014B000) // initialize framebuffer
	drawPalette(framebuffer, ColorArray) // draw palette
	gameSetup() // initialize game setup
	initBrushArray(WHITE32, BrushArrayLoc) // intitialize brush array
	SeeInstructions:
	WaitLoop:
		WaitScanline($1E0) // PeterLemon macro
		ReadController(PIF2) // PeterLemon macro, read controller, t0 = controller buttons
		andi t3, t0, JOY_START
		beqz t3, WaitLoop
		nop
	Swap:
	lui t0, VI_BASE
	li t1, fb1
	sw t1, VI_ORIGIN(t0)// swap buffer

DrawLine:
		// PeterLemon macro ------------------------------------------
        //InitController(PIF1) // initialize controller
		// -----------------------------------------------------------
    ReadLoop:
		addi a1, r0, 300 // can be adjusted to change controller sensitivity
		WaitScanline:
			// PeterLemon macro --------------------------------------
        	WaitScanline($1E0)
			// --------------------------------------------------------
			bnez a1, WaitScanline
			addi a1, a1, -1
		// PeterLemon macro ------------------------------------------
		ReadController(PIF2) // read controller, t0 = controller buttons
		// ------------------------------------------------------------
		add t8, r0, t4 // store old current loc
        EraseMode:
			andi t3, t0, JOY_CUP
           	beqz t3, DrawMode
            nop
			changeModeErase() // if JOY_CUP was pressed, put game in erase mode
			j Render
			nop

		DrawMode:
			andi t3, t0, JOY_CDOWN
           	beqz t3, MoveMode
            nop
			changeModeDraw() // if JOY_CDOWN was pressed, put game in draw mode
			j Render
			nop

		MoveMode:
			andi t3, t0, JOY_CRIGHT
			beqz t3, ColorSelect
			nop
			changeModeMove() // if JOY_CRIGHT was pressed, put game in move mode
			j Render
			nop
		
		ColorSelect:
			andi t3, t0, JOY_CLEFT
        	beqz t3, Up
           	nop
			colorSelection(ColorArray) // if JOY_CLEFT was pressed, change the drawing color

		Up: // if user pressed up on dpad, move pixel up one row
			andi t3 , t0, JOY_UP
			beqz t3, Down
			nop  
			addi t4, t4, -1280
			upCheck(framebuffer) // bound check

		Down: // if user pressed down on dpad, move pixel down one row
			andi t3, t0, JOY_DOWN
			beqz t3,Left
			nop
			addi t4, t4, 1280
			downCheck() // bound check

		Left: // if user pressed left on dpad, move pixel left
			andi t3,t0,JOY_LEFT
			beqz t3, Right
 			nop
			addi t4, t4, -4
			addi t5, t5, -4 // update x coord
			checkLeft() // bound check

		Right: // if user pressed right on dpad, move pixel right
			andi t3,t0,JOY_RIGHT
			beqz t3, SoftReset
 			nop
			addi t4, t4, 4
			addi t5, t5, 4 // update x coord
			checkRight() // bound check
		
		SoftReset:
			andi t3, t0, JOY_B
			beqz t3, HardReset
 			nop
			beqz t6, FixBrushBug
			addi t0, r0, 2
			beq t6, t0, FixBrushBug
			nop
			FixEraserBug:
				add a0, r0, t8
				jal SaveOrRestoreEraser
				addi a2, r0, -1
				j Swap2
				nop
			FixBrushBug:
				add a0, r0, t8
				jal SaveOrRestoreBrush
				addi a2, r0, -1
			Swap2:
			addi t6, r0, 2
			lui t0, VI_BASE
			li t1, fb2
			sw t1, VI_ORIGIN(t0) // swap buffer back to title screen buffer
			j SeeInstructions // jump to top
			nop
		HardReset:
			andi t3, t0, JOY_Z
			beqz t3, Render
 			nop
			lui t0, VI_BASE
			li t1, fb2
			sw t1, VI_ORIGIN(t0) // swap buffer back to title screen buffer
			j Restart // jump to top
			nop

	Render: // draws screen
        beqz t6, Draw
        nop
		addi t0, r0, 2
		beq t6, t0, Move
		nop
        Erase: // erase mode
			eraseRender()
		    j ReadLoop
		    nop

        Draw: // draw mode
			drawRender()
			j ReadLoop
	 		nop

		Move: // move mode
			moveRender()
		    j ReadLoop
		    nop

	BrushSprite: // draw brush sprite
		drawBrushSprite()

	SaveOrRestoreBrush: // save or restore brush
		saveOrRestoreBrush()
	
	EraserSprite: // draw eraser sprite
		drawEraserSprite()

	SaveOrRestoreEraser: // save or restore eraser
		saveOrRestoreEraser()
	
	// PeterLemon PIF initializing ----------------------------------------
    align(8) // Align 64-Bit

    PIF1:
    dw $FF010401,0
    dw 0,0
    dw 0,0
    dw 0,0
    dw $FE000000,0
    dw 0,0
    dw 0,0
    dw 0,1

    PIF2:
    fill 64 // Generate 64 Bytes Containing $00
	// ----------------------------------------------------

align(8)
	EraserArrayLoc:
	fill 360

align(8)
	BrushArrayLoc:
	fill 152

align(8)
	ColorArray:
	dw RED32
    dw ORANGE32
    dw CADMIUM_YELLOW32
    dw LIME_GREEN32
    dw DEEP_SKY_BLUE32
    dw DARK_VIOLET32
    dw HOT_PINK32
    dw BLACK32

align(4)
Title:
  db "MIPS PAINT"

ToPlay:
  db "TO PLAY:"

Inst1:
  db "1. use the D-PAD to move the brush"

Inst2:
  db "2. press C-UP to erase"

Inst3:
  db "3. press C-DOWN to draw"

Inst4:
  db "4. press C-RIGHT to move"

Inst5:
  db "5. press C-LEFT in the palette to"

Inst5.2:
  db "   change color"

Inst6:
  db "6. press B to see instructions"

Inst7:
  db "7. press Z to restart"

Press:
  db "PRESS"

Press2:
  db "START"

align(4) // Align 32-Bit
// PeterLemon font --------------------------
insert FontBlack, "FontBlack8x8.bin"
insert FontRed, "FontRed8x8.bin"
include "N64_FONT.S"
// ------------------------------------------
