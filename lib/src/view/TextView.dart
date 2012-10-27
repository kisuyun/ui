//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 19, 2012 12:10:33 PM
// Author: tomyeh

/**
 * Displays plain text or a fragment of HTML content to the user.
 *
 * Notice that there are two kinds of text: plain text and HTML fragment.
 * You can specify the normal text with [text], or the HTML fragment with [innerHTML].
 * The later inocation will override the previous ones.
 *
 * When displaying HTML fragement, an extra CSS class called `v-html` will be added.
 * Thus, you can customize the look of embedding HTML fragment different from text.
 */
class TextView extends View {
  String _text = ""; //we have to preserve it since it can't be retrieve from node

  /** Instantaites with a plain text.
   * The text will be encoded to make sure it is valid HTML text.
   */
  TextView([String text]) {
    if (text != null && !text.isEmpty())
      this.text = text; //have render_() called
  }
  /** Instantiates with a HTML fragment.
   *
   * + [html] specifies a HTML fragment.
   * Notie it must be a valid HTML fragment. Otherwise, the result is
   * unpreditable.
   */
  TextView.fromHTML(String html) {
    this.html = html; //have render_() called
  }

  //@override
  String get className => "TextView"; //TODO: replace with reflection if Dart supports it

  /** Returns the text.
   */
  String get text => this._text;
  /** Sets the text displayed in this view.
   */
  void set text(String text) {
    _text = text != null ? text: "";
    classes.remove("v-html");
    updateInner_();
  }
  /** Returns the HTML displayed in this view.
   */
  String get html => node.innerHTML;
  /** Sets the HTML displayed in this view.
   */
  void set html(String html) {
    _text = "";
    classes.add("v-html");
    updateInner_(html);
  }

  /** Called to update the DOM element, when the content of this view
   * is changed.
   *
   * Default: invoke [innerHTML_] to retrieve the content
   * and then update [node]'s innerHTML.
   */
  void updateInner_([String html]) {
    if (html == null) html = "";
    node.innerHTML = "$encodedText$html";
  }
  /** Returns the encodes the text ([text]).
   *
   * Default: it encodes [text] by replacing linefeed with <br/>, if any.
   */
  String get encodedText => XMLUtil.encode(text, multiline:true);

  /** Creates and returns the DOM elements of this view.
   *
   * Default: it creates a DIV element containing [innerHTML_]
   */
  //@override
  Element render_()
  => new Element.html("<div>$encodedText</div>");

  //@override
  /** Returns false to indicate this view doesn't allow any child views.
   */
  bool isViewGroup() => false;
  //@override
  String toString() => "$className($text)";
}
