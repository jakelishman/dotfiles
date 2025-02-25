import os

from pygments.style import Style
from pygments import token

base03  = 'ansiblack     bold'
base02  = 'ansiblack     nobold'
base01  = 'ansigreen     bold'
base00  = 'ansiyellow    bold'
base0   = 'ansiblue      bold'
base1   = 'ansicyan      bold'
base2   = 'ansiwhite     nobold'
base3   = 'ansiwhite     bold'
yellow  = 'ansiyellow    nobold'
orange  = 'ansired       bold'
red     = 'ansired       nobold'
magenta = 'ansimagenta   nobold'
violet  = 'ansimagenta   bold'
blue    = 'ansiblue      nobold'
cyan    = 'ansicyan      nobold'
green   = 'ansigreen     nobold'

dark = os.environ.get("ITERM_PROFILE") == "Dark"

class SolarizedStyle(Style):
    background_color = base03 if dark else base3
    styles = {
        token.Keyword: green,
        #token.Keyword.Constant: orange,
        #token.Keyword.Declaration: blue,
        #token.Keyword.Namespace: magenta,
        #token.Keyword.Pseudo
        #token.Keyword.Reserved: blue,
        token.Keyword.Type: yellow,

        #token.Name
        token.Name.Attribute: base0 if dark else base00,
        token.Name.Builtin: blue,
        token.Name.Builtin.Pseudo: (base01 if dark else base1) + ' italic',
        token.Name.Class: magenta,
        token.Name.Constant: orange,
        token.Name.Decorator: orange,
        token.Name.Entity: orange,
        token.Name.Exception: orange,
        token.Name.Function: blue,
        #token.Name.Label
        token.Name.Namespace: magenta,
        #token.Name.Other
        token.Name.Tag: blue,
        token.Name.Variable: base0 if dark else base00,
        #token.Name.Variable.Class
        #token.Name.Variable.Global
        #token.Name.Variable.Instance

        token.Literal: cyan,
        #token.Literal.Date
        token.String: cyan,
        #token.String.Backtick: base0,
        #token.String.Char: cyan,
        token.String.Doc: (base01 if dark else base1) + ' italic',
        #token.String.Double
        token.String.Escape: orange,
        token.String.Heredoc: base0 if dark else base00,
        #token.String.Interpol
        #token.String.Other
        token.String.Regex: red,
        #token.String.Single
        #token.String.Symbol
        #token.Number: cyan,
        #token.Number.Float
        #token.Number.Hex
        #token.Number.Integer
        #token.Number.Integer.Long
        #token.Number.Oct

        token.Operator: base0 if dark else base00,
        #token.Operator.Word

        #token.Punctuation: orange,

        token.Comment: (base01 if dark else base1) + ' italic',
        #token.Comment.Multiline
        #token.Comment.Preproc: green,
        #token.Comment.Single
        #token.Comment.Special: green,

        #token.Generic
        token.Generic.Deleted: cyan,
        token.Generic.Emph: 'italic',
        token.Generic.Error: red,
        token.Generic.Heading: orange,
        token.Generic.Inserted: green,
        #token.Generic.Output
        #token.Generic.Prompt
        token.Generic.Strong: 'bold',
        token.Generic.Subheading: orange,
        #token.Generic.Traceback

        token.Token: base1 if dark else base01,
        token.Token.Other: orange,
    }

c = get_config()

c.TerminalInteractiveShell.highlighting_style = SolarizedStyle
c.TerminalInteractiveShell.highlighting_style_overrides = {
        token.Token.Prompt: (base01 if dark else base1) + ' italic',
        token.Token.PromptNum: (base01 if dark else base1) + ' italic',
        token.Token.OutPrompt: (base01 if dark else base1) + ' italic',
        token.Token.OutPromptNum: (base01 if dark else base1) + ' italic',
    }

c.TerminalIPythonApp.display_banner = False
c.TerminalInteractiveShell.autoformatter = None
c.TerminalInteractiveShell.automagic = False
c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.history_length = 100_000
c.TerminalInteractiveShell.history_load_length = 1_000
c.TerminalInteractiveShell.prompt_includes_vi_mode = False


# Hack into the traceback formatter to set the style.
from IPython.core.ultratb import VerboseTB
VerboseTB._tb_highlight = f"bg:#eee8d5"
VerboseTB._tb_highlight_style = "solarized-light"
