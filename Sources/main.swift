import Foundation
import ANSITerminal

// define some special constants for easy typing
let ESCAPE = NonPrintableChar.escape.char()
let DELETE = NonPrintableChar.del.char()
let RETURN = NonPrintableChar.enter.char()
let BACKSP = NonPrintableChar.erase.char()
let HTAB   = NonPrintableChar.tab.char()
let SPACE  = NonPrintableChar.space.char()
let DELAY  = 1000

func writeBack(_ txt: String, suspend: Int = 0) {
  restoreCursorPosition()
  write(txt)
  if suspend > 0 { delay(suspend) }
  restoreCursorPosition()
}

var now = Date()
let fmt = DateFormatter()
fmt.dateFormat = "dd-MM-yyyy HH:mm.ss"

// program title
// clearScreen()
writeln()
writeln(" ANSITerminal Demo ".bold.yellow.onBlue)
let clockPos = readCursorPos()
writeln(fmt.string(from: now).green)
writeln("–––––––––––––––––––")

// color prompt
write("Code pressed".yellow+" is ")
storeCursorPosition()

moveLineDown(3)
write("Press any key, "+"ESC".lightRed+" to quit.")

// waiting for keyboard input
var str  = ""
while true {
  clearBuffer()
  var quit = false
  var chr  = NonPrintableChar.none.char()

  // check for key pressed
  if keyPressed() {
    chr = readChar()
    str = "\(chr.asciiValue!)"

    // move to next line
    moveLineDown()
    write("Char pressed is ")
    setColor(fore: .yellow)

    // check for ESC sequence
    if chr == ESCAPE {
      let key = readKey()

      // it's just a regular ESC
      if key.code == .none {
        write("ESC ")
        quit = true
      }
      // it's indeed an ESC sequence
      else {
        write("\(key.code)")
        // write meta key symbols
        if !key.meta.isEmpty {
          if key.meta.contains(.control) { write("+⌃ ") }
          if key.meta.contains(.shift) { write("+⇧ ") }
          if key.meta.contains(.alt) { write("+⌥ ") }
        }
        write(" ")
      }
    }
    // make space more visible
    else if chr == SPACE {
      write(" ".onDarkGray," ")
    }
    // write some non printable symbols
    else if isNonPrintable(char: chr) {
           if chr == RETURN { write("↩︎  ") }
      else if chr == DELETE { write("⌦  ") }
      else if chr == BACKSP { write("⌫  ") }
      else if chr == HTAB   { write("⇥  ") }
      else { write("¿ ") }
    }
    // it's just a regular key
    else {
      write("\(chr) ")
    }

    clearToEndOfLine()
  }
  // animating dots and clock while waiting
  else {
    // clock
    cursorOff()
    now = Date()
    moveTo(clockPos.row, clockPos.col)
    write(fmt.string(from: now).green)
    delay(DELAY)
    cursorOn()

    // pressed char
    writeBack(str, suspend: DELAY)

    // 3 dots animation
    str.count >= 1 ? moveRight() : write("."); delay(DELAY)
    str.count >= 2 ? moveRight() : write("."); delay(DELAY)
    str.count >= 3 ? moveRight() : write("."); delay(DELAY)
    moveLeft(3)
  }

  // add new line on quit
  if quit {
    setDefault()
    writeln()
    clearLine()
    break
  }
}

writeln()
clearLine()
print("Thank you!".lightBlue.bold)
