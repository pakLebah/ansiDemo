import ANSITerminal

// define some special constants for easy typing
let ESCAPE = NonPrintableChar.escape.char()
let DELETE = NonPrintableChar.del.char()
let RETURN = NonPrintableChar.enter.char()
let BACKSP = NonPrintableChar.erase.char()
let HTAB   = NonPrintableChar.tab.char()
let SPACE  = NonPrintableChar.space.char()
let DELAY  = 10000

func writeBack(_ txt: String, suspend: Int = 0) {
  restoreCursorPosition()
  write(txt)
  if suspend > 0 { delay(suspend) }
  restoreCursorPosition()
}

// color prompt
// clearScreen()
writeln()
print(" ANSITerminal Demo ".bold.yellow.onBlue)
print("–––––––––––––––––––")
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
  // animating dots while waiting
  else {
    writeBack(str, suspend: DELAY)

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
