package main

import (
	"fmt"
	"os"

	"github.com/atotto/clipboard"
	"github.com/russross/blackfriday"
	"gopkg.in/qml.v1"
)

type HTMLText struct {
	Text string
	qml.Object
}

func (h *HTMLText) CopyToClip(text string) {
	formatted := blackfriday.MarkdownCommon([]byte(text))
	_ = clipboard.WriteAll(string(formatted))
}
func (h *HTMLText) SetHTMLText(text string) {
	formatted := blackfriday.MarkdownCommon([]byte(text))
	h.Text = string(formatted)
}

var ctx qml.Context

func run() error {
	qml.RegisterTypes("TextConverter", 1, 0, []qml.TypeSpec{{
		Init: func(h *HTMLText, obj qml.Object) {
			h.Text = "Rich Text"
		},
	},
	})
	engine := qml.NewEngine()
	engine.On("quit", func() { os.Exit(0) })

	component, err := engine.LoadFile("assets/main.qml")
	if err != nil {
		return err
	}

	ctx = *engine.Context()
	ctx.SetVar("rttext", "rich text")
	ctx.SetVar("mdtext", "markdown text")

	win := component.CreateWindow(nil)
	win.Show()
	win.Wait()

	return nil
}

func main() {
	if err := qml.Run(run); err != nil {
		fmt.Fprintf(os.Stderr, "ERR: %v\n", err)
		os.Exit(1)
	}
}
