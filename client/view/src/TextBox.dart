//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, May 22, 2012 10:46:08 AM
// Author: tomyeh

/**
 * A text box to get input from the user or to to display text.
 */
class TextBox extends View {
	String _value;
	String _type;
	String _placeHolder = "";
	int _maxLength = -1, _cols = 20, _rows = 2;
	bool _disabled = false, _autoFocus = false, _autoComplete = true;

	TextBox([String value="", String type="text", bool autoFocus=false]) {
		vclass = "v-TextBox";
		_value = value;
		_type = type;
		_autoFocus = autoFocus;
	}

	/** Returns the type of data being placed in this text box.
	 */
	String get type() => _type;
	/** Sets the type of data being placed in this text box.
	 * <p>Default: text.
	 * <p>Allowed values:
	 * <ul>
	 * <li>text - plain text</li>
	 * <li>multiline - multiline plain text</li>
	 * <li>password - </li>
	 * <li>number - </li>
	 * <li>color - </li>
	 * <li>range - </li>
	 * <li>date - </li>
	 * <li>url - </li>
	 * <li>tel - </li>
	 * <li>email - </li>
	 */
	void set type(String type) {
		if (_type != type) {
			if (type == null || type.isEmpty())
				throw const UiException("type required");

			final bool oldMultiline = _multiline;
			_type = type;

			if (inDocument)
				if (oldMultiline != _multiline) { //rerender required
					addToDocument(node, outer: true);
						//we don't use invalidate since the user might modify other properties later
				} else {
					inputNode.type = type;
				}
		}
	}
	/** Returns whether it allows the user to enter multiple lines of text.
	 */
	bool get _multiline() => _type == "multiline";

	/** Returns the value of this text box.
	 */
	String get value() => _value;
	/** Sets the value of this text box.
	 * <p>Default: an empty string.
	 */
	void set value(String value) {
		_value = value;
		final InputElement n = inputNode;
		if (n != null)
			n.value = value;
	}

	/** Returns whether it is disabled.
	 * <p>Default: false.
	 */
	bool get disabled() => _disabled;
	/** Sets whether it is disabled.
	 */
	void set disabled(bool disabled) {
		_disabled = disabled;
		InputElement n = inputNode;
		if (n != null)
			n.disabled = _disabled;
	}

	/** Returns whether this input should automatically get focus.
	 * <p>Default: false.
	 */
	bool get autoFocus() => _autoFocus;
	/** Sets whether this input should automatically get focus.
	 */
	void set autoFocus(bool autoFocus) {
		_autoFocus = autoFocus;
		if (autoFocus) {
			InputElement n = inputNode;
			if (n != null)
				n.focus();
		}
	}

	/** Returns whether to predict the value based on ealier typed value.
	 * When a user starts to type in,
	 * a list of options will be  displayed to fill the box, based on
	 * ealier typed values
	 * <p>Default: true (enabled).
	 */
	bool get autoComplete() => _autoComplete;
	/** Sets whether to predict the value based on ealier typed value.
	 */
	void set autoComplete(bool autoComplete) {
		_autoComplete = autoComplete;
		InputElement n = inputNode;
		if (n != null)
			n.autoComplete = _autoComplete;
	}

	/** Returns a short hint that describes this text box.
	 * The hint is displayed in the text box when it is empty, and
	 * disappears when it gets focus.
	 * <p>Default: an empty string.
	 */
	String get placeHolder() => _placeHolder;
	/** Returns a short hint that describes this text box.
	 * <p>Default: an empty string.
	 */
	void set placeHolder(String placeHolder) {
		_placeHolder = placeHolder;
		final InputElement n = inputNode;
		if (n != null)
			n.placeHolder = _placeHolder;
	}

	/** Returns the width of this text box in average character width.
	 * <p>Default: 20.
	 */
	int get cols() => _cols;
	/** Sets the width of this text box in average character width.
	 * <p>Default: 20.
	 */
	void set cols(int cols) {
		_cols = cols;
		InputElement n = inputNode;
		if (n != null)
			n.cols = _cols;
	}
	/** Returns the height of this text box in number of lines.
	 * <p>Default: 2.
	 * <p>Notice that it is meaningful only if [type] is "multiline".
	 */
	int get rows() => _rows;
	/** Sets the height of this text box in number of lines.
	 * <p>Default: 2.
	 * <p>Notice that it is meaningful only if [type] is "multiline".
	 */
	void set rows(int rows) {
		_rows = rows;
		InputElement n = inputNode;
		if (n != null)
			n.rows = _rows;
	}

	/** Returns the maximal allowed number of characters.
	 * <p>Default: -1 (no limitation).
	 */
	int get maxLength() => _maxLength;
	/** Sets the maximal allowed number of characters.
	 * <p>Default: 0 (no limitation).
	 */
	void set maxLength(int maxLength) {
		_maxLength = maxLength;
		InputElement n = inputNode;
		if (n != null)
			n.maxLength = _maxLength;
	}

	/** Returns the INPUT element in this view.
	 */
	InputElement get inputNode() => getNode("inp");

	//@Override
	/** Returns the HTML tag's name representing this view.
	 * <p>Default: <code>input</code> or <code>textarea</code> if [mulitline].
	 */
	String get domTag_() => _multiline ? "textarea": "input";
	//@Override
	void domInner_(StringBuffer out) {
		if (_multiline)
			out.add(StringUtil.encodeXML(value));
	}
	//@Override
	void domAttrs_(StringBuffer out,
	[bool noId=false, bool noStyle=false, bool noClass=false]) {
		if (!_multiline) {
			out.add(' type="').add(type).add('"');
			if (!value.isEmpty())
				out.add(' value="').add(StringUtil.encodeXML(value)).add('"');
			if (rows != 2)
				out.add(' rows="').add(rows).add('"');
		}
		if (cols != 2)
			out.add(' cols="').add(cols).add('"');
		if (disabled)
			out.add(' disabled="disabled"');
		if (autoFocus)
			out.add(' autofocus="autofocus"');
		if (!autoComplete)
			out.add(' autocomplete="off"');
		if (maxLength > 0)
			out.add(' maxlength="').add(maxLength).add('"');
		if (!placeHolder.isEmpty())
			out.add(' placeholder="').add(StringUtil.encodeXML(placeHolder)).add('"');
		super.domAttrs_(out, noId, noStyle, noClass);
	}
	//@Override
	/** Returns whether this view allows any child views.
	 * <p>Default: false.
	 */
	bool isChildable_() => false;
	//@Override
	int measureWidth(MeasureContext mctx)
	=> layoutManager.measureWidthByContent(mctx, this, true);
	//@Override
	int measureHeight(MeasureContext mctx)
	=> layoutManager.measureHeightByContent(mctx, this, true);
	//@Override
	String toString() => "TextBox('$value')";
}