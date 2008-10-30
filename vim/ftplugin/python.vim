python << EOF
def SetPythonBreakpoint():
    import re
    nLine = int( vim.eval( 'line(".")'))

    strLine = vim.current.line
    strWhite = re.search( '^(\s*)', strLine).group(1)

    vim.current.buffer.append(
       "%(space)simport pdb; pdb.set_trace() %(mark)s Breakpoint %(mark)s" %
         {'space':strWhite, 'mark': '#' * 30}, nLine - 1)

vim.command( 'ino <f7> <C-o>:py SetPythonBreakpoint()<cr>')

def RemovePythonBreakpoints():
    import re

    nCurrentLine = int( vim.eval( 'line(".")'))

    nLines = []
    nLine = 1
    for strLine in vim.current.buffer:
        if 'pdb.set_trace()' in strLine:
            nLines.append( nLine)
        nLine += 1

    nLines.reverse()

    for nLine in nLines:
        vim.command( 'normal %dG' % nLine)
        vim.command( 'normal dd')
        if nLine < nCurrentLine:
            nCurrentLine -= 1

    vim.command( 'normal %dG' % nCurrentLine)

vim.command( 'ino <S-F7> <C-o>:py RemovePythonBreakpoints()<cr>')
EOF
