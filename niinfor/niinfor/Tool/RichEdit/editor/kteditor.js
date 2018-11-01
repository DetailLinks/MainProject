! function (e) {
	"use strict";
	void 0 !== window && (window.MEditor = function (jquery) {
		var utils = {
			getSelection: function () {
				return (window.getSelection || document.getSelection)()
			},
			getRange: function () {
				var range;
				try {
					range = this.getSelection().getRangeAt(0)
				} catch (err) {
					console.log(err)
				}
				return range
			},
			findParentsNode: function (e, n) {
				var t = jquery(e),
					o = e.nodeName.toUpperCase(),
					i = new RegExp("^(" + n.toUpperCase().split(",").join("|") + ")$");
				return i.test(o) ? t : t.parents(n.toLowerCase())
			},
			findBlockNode: function (e) {
				var n;
				return 3 === e.nodeType && (e = e.parentNode), n = jquery(e), "block" === n.css("display") || "LI" === e.nodeName.toUpperCase() ? n : utils.findBlockNode(e.parentNode)
			},
			colorRGBtoHex: function (color) {
				var rgb = color.split(',');
				var r = parseInt(rgb[0].split('(')[1]);
				var g = parseInt(rgb[1]);
				var b = parseInt(rgb[2].split(')')[0]);
				var hex = "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
				return hex;
			},
			pushCommandState: function (e, n, t) {
				return document.queryCommandState(n) ? e.indexOf(n) < 0 && e.push(n) : t && false !== t || 0 <= e.indexOf(n) && e.splice(e.indexOf(n), 1), e
			},
			getSelectionCoords: function (e) {
				var n, t, o, i = (e = e || window).document,
					a = i.selection,
					d = 0,
					r = 0;
				if (a) "Control" !== a.type && ((n = a.createRange()).collapse(true), d = n.boundingLeft, r = n.boundingTop);
				else if (e.getSelection && (a = e.getSelection()).rangeCount && ((n = a.getRangeAt(0).cloneRange()).getClientRects && (n.collapse(true), 0 < (t = n.getClientRects()).length && (o = t[0]), o && (d = o.left, r = o.top)), 0 === d && 0 === r || void 0 === o)) {
					var l = i.createElement("span");
					if (l.getClientRects) {
						l.appendChild(i.createTextNode("​")), n.insertNode(l), o = l.getClientRects()[0], d = o.left, r = o.top;
						var pnode = l.parentNode;
						pnode.removeChild(l), pnode.normalize()
					}
				}
				return {
					x: d,
					y: r
				}
			}
		};

		function Editor(elem) {
			var node = jquery(elem).prop("contenteditable", true),
				thiz = this,
				sel = utils.getSelection(),
				range = utils.getRange();
			window.android || window.webkit || node.focus(),
				jquery(document).off("selectionchange.range").on("selectionchange.range", function () {
					node.is(":focus") && (thiz.blurRange = range = utils.getRange(), thiz.blurSelection = sel = utils.getSelection())
				}),

				node.off("input.range,blur.range").on("input.range,blur.range", function () {
					thiz.blurRange = range = utils.getRange(), thiz.blurSelection = sel = utils.getSelection()
				}),
				thiz.blurRange = range, thiz.blurSelection = sel
		}
		return function (editId) {
			var thiz = this,
				myEditor = new Editor(editId),
				editor = jquery(editId),
				stateCb = jquery.Callbacks(),
				textCb = jquery.Callbacks(),
				content = "",
				maxLen = 5000,
				keyBoardH = 300,
				states = [];

			function adjust(eid) {
				var coord = utils.getSelectionCoords(window),
					height = document.body.clientHeight - keyBoardH - 130;
				if (coord.y < 0 || coord.y > height) {
					var offY = coord.y + window.scrollY;
					jquery("body").stop().animate({
						scrollTop: offY - height
					}, 300, "swing", function () {
						var coord2 = utils.getSelectionCoords(window);
						if (coord2.y > height) {
							var offY2 = coord2.y - height;
							jquery(eid).css("padding-bottom", offY2), jquery("body").stop().animate({
								scrollTop: window.scrollY - (coord2.y - height)
							}, 300, "swing", function () {})
						}
					})
				} else {
					jquery("body").stop()
				}
			}
			editor.empty().html("<p><br/></p>");
			editor.off("keypress.li").on("keypress.li", function (e) {
				var parents, pparent, pobj, range = myEditor.blurRange,
					sel = utils.getSelection();
				if (13 === e.which && range && (parents = utils.findParentsNode(range.endContainer, "li"), pparent = parents.parent(), parents.length && "" === parents.text())) {
					if (parents.get(0) !== pparent.children().last().get(0)) {
						return parents.before(jquery("<li>").html("<br/>"))
					} else {
						return (pparent.parent().after(pobj = jquery("<p>").html(parents.html())), parents.remove(), sel.setPosition(pobjs.get(0), 0)), e.stopPropagation(), false
					}
				}
			});
			jquery(document).off("selectionchange.block").on("selectionchange.block", function () {
				var range = myEditor.blurRange;
				range && utils.findParentsNode(range.endContainer, "div").each(function (e, n) {
					n !== editor.get(0) && n.parentNode === editor.get(0) && document.execCommand("formatBlock", false, "<p>")
				})
			});

			jquery(document).off("selectionchange.link").on("selectionchange.link", function () {
				var pnode, pos, json, sel = utils.getSelection(),
					range = utils.getRange(),
					newRange = document.createRange();
				if (!range) {
					return
				}
				pnode = utils.findParentsNode(range.startContainer, "a")
				if (pnode.length && !pnode.attr("data-link")) {
					newRange.selectNodeContents(pnode.get(0));
					if (0 < range.startOffset) {
						sel.setPosition(newRange.endContainer, newRange.endOffset);
					}
					pos = pnode.position(),
						json = JSON.stringify({
							title: pnode.get(0).innerText.replace(/^ */g, ""),
							href: pnode.prop("href"),
							left: pos.left + pnode.width(),
							linkWidth: pnode.width(),
							offsetTop: editor.offset().top,
							top: pos.top
						});
					window.android && window.android.updateLink(json);
					window.webkit && window.webkit.messageHandlers.updateLink.postMessage(json)
				} else {
					window.android && window.android.updateLink("");
					window.webkit && window.webkit.messageHandlers.updateLink.postMessage("");
				}
			});
			jquery(document).off("selectionchange.bar").on("selectionchange.bar", function () {
				utils.getSelection().isCollapsed ? (window.android && window.android.editorBar(true), window.webkit && window.webkit.messageHandlers.editorBar.postMessage(true)) : (window.android && window.android.editorBar(false), window.webkit && window.webkit.messageHandlers.editorBar.postMessage(false))
			});
			jquery(document).off("selectionchange.state").on("selectionchange.state", function () {
				thiz.statesChanged();
			});
			thiz.statesChanged = function() {
				var cmds = [];
				["bold", "italic", "underline", "insertOrderedList", "insertUnorderedList", "justifyLeft", "justifyCenter", "justifyRight"].map(function (cmd) {
					utils.pushCommandState(cmds, cmd, true)
				});
				states = (states = cmds.concat(document.queryCommandValue("formatBlock"), document.queryCommandValue("foreColor"))).map(function (e) {
					if (e.indexOf("rgb") == 0) {
						return utils.colorRGBtoHex(e)
					}
					return "p" === e && (e = "h3"), e
				});
				stateCb.fire(states), console.log(states)
			};
			editor.off("keyup.dellink").on("keyup.dellink", function (e) {
				var n = myEditor.blurRange;
				if (8 === e.which && n && utils.findParentsNode(n.endContainer, "a").length) return e.stopPropagation(), thiz.deleteLink(), false
			});
			editor.off("keyup.clear").on("keyup.clear", function (e) {
				var n = myEditor.blurRange,
					t = utils.getSelection(),
					o = jquery(n.endContainer).parent("h1,h3,h5,p");
				8 === e.which && (editor.children().length || editor.empty().html("<p><br/></p>"), o.length && "" === o.text() && (o.html("<br/>"), t.setPosition(o.get(0), 0)))
			});
			editor.off("keypress.max").on("keypress.max", function (e) {
				var n = "不能超过" + maxLen + "字";
				if (editor.text().length > maxLen && (window.android && window.android.toast(n), window.webkit && window.webkit.messageHandlers.toast.postMessage(n), 8 !== e.which || 13 !== e.which)) return e.stopPropagation(), false
			});
			editor.off("input.callback").on("input.callback", function () {
				textCb.fire(editor.text())
			});
			editor.off("input.max").on("input.max", function () {
				var e = "不能超过" + maxLen + "字",
					n = utils.getSelection();
				editor.text().length > maxLen ? (window.android && window.android.toast(e), window.webkit && window.webkit.messageHandlers.toast.postMessage(e), editor.html(content), n.selectAllChildren(editor.get(0)), n.collapseToEnd()) : content = editor.html(), window.android && window.android.text(editor.html()), window.webkit && window.webkit.messageHandlers.text.postMessage(editor.html())
			});
			jquery(document).off("touchmove.scroll").on("touchmove.scroll", function () {
				var e = utils.getSelection();
				e.isCollapsed && editor.blur()
			});
			window.webkit && (jquery(document).off("click.stop").on("click.stop", function () {
					jquery("body").stop()
				}),
				jquery(document).off("selectionchange.resetcart").on("selectionchange.resetcart", function () {
					var sel = utils.getSelection();
					sel.isCollapsed && adjust(editId)
				}),
				jquery(document).off("click.focus").on("click.focus", function () {
					editor.is(":focus") || editor.focus()
				}));
			thiz.keyboardHeight = function (e) {
				var n = e + (0 < e ? 100 : 30);
				editor.css("paddingBottom", n + "px"), 0 < e && (keyBoardH = e)
			};
			thiz.getSelectionCoords = function () {
				window.android && window.android.getSelectionCoords(JSON.stringify(utils.getSelectionCoords(window)))
			};
			thiz.commands = function () {
				return states;
			};
			thiz.listenerSelectionChange = function (e) {
				e && "function" == typeof e && stateCb.add(e)
			};
			thiz.listenerTextChange = function (e) {
				e && "function" == typeof e && textCb.add(e)
			};
			thiz.deleteLink = function () {
				var e = myEditor.blurRange,
					n = utils.findParentsNode(e.endContainer, "a"),
					t = utils.getSelection(),
					o = document.createRange();
				n.length && (o.selectNode(n.get(0)), o.deleteContents(), t.addRange(o)), t.collapse(e.endContainer, e.endOffset)
			};
			thiz.updateLink = function (e, n) {
				var t = myEditor.blurRange,
					o = t.endContainer,
					i = utils.getSelection(),
					a = document.createRange(),
					d = utils.findParentsNode(o, "a");
				editor.is(":focus") || editor.focus(), d.length ? (i.removeAllRanges(), a.selectNode(d.get(0)), a.deleteContents(), i.addRange(a), document.execCommand("insertHTML", false, ['<a href="' + n + '" target="_self" class="link">', '<span class="iconfont icon-iconfontlink">&nbsp;</span>' + jquery.trim(e), "</a>"].join("")), a.collapse(a.endContainer, a.endOffset)) : i.collapse(o, t.endOffset), editor.scrollTop(editor.prop("scrollHeight"))
			};
			thiz.createLink = function (e, n) {
				var t = myEditor.blurRange,
					o = utils.getSelection();
				editor.is(":focus") || editor.focus(), t && (t.collapsed ? (o.collapse(t.endContainer, t.endOffset), document.execCommand("insertHTML", false, ['<a href="' + n + '" target="_self" class="link" data-link="create">', '<span class="iconfont icon-iconfontlink">&nbsp;</span>' + e, "</a>"].join("")), setTimeout(function () {
					utils.findParentsNode(o.anchorNode, "a").removeAttr("data-link")
				}, 500), editor.scrollTop(editor.prop("scrollHeight"))) : o.collapse(t.endContainer, t.endOffset))
			};
			thiz.insertOrderedList = function () {
				var e, n = myEditor.blurRange,
					t = n.endContainer,
					o = n.endOffset,
					i = utils.getSelection(),
					a = utils.findParentsNode(t, "ul"),
					d = document.createRange();
				utils.findParentsNode(t, "h1,h3,h5");
				i.isCollapsed ? a.length ? (e = a.find("li"), i.removeAllRanges(), d.selectNodeContents(a.get(0)), i.addRange(d), 1 < e.length && "" === e.last().text() && e.last().remove(), document.execCommand("insertOrderedList", false, null), i.collapseToEnd()) : (i.collapse(t, o), document.execCommand("insertOrderedList", false, null)) : document.execCommand("insertOrderedList", false, null)
			};
			thiz.insertUnorderedList = function () {
				var e, n = myEditor.blurRange,
					t = n.endContainer,
					o = utils.getSelection(),
					i = utils.findParentsNode(t, "ol"),
					a = document.createRange();
				utils.findParentsNode(t, "h1,h3,h5");
				o.isCollapsed ? i.length ? (e = i.find("li"), o.removeAllRanges(), a.selectNodeContents(i.get(0)), o.addRange(a), 1 < e.length && "" === e.last().text() && e.last().remove(), document.execCommand("insertUnorderedList", false, null), o.collapseToEnd()) : (o.collapse(t, n.endOffset), document.execCommand("insertUnorderedList", false, null)) : document.execCommand("insertUnorderedList", false, null)
			};
			thiz.foramtParagraph = function (e) {
				var n, t, range = myEditor.blurRange;
				if (!range) {
					return
				}
				var i = range.endContainer,
					a = range.endOffset,
					d = utils.getSelection(),
					r = document.createRange(),
					l = utils.findParentsNode(i, "ol,ul");
				"H3" === e.toUpperCase() && (e = "p");
				l.length ? (d.removeAllRanges(), r.selectNode(l.get(0).parentNode), r.deleteContents(), r.insertNode(n = jquery("<" + e + ">").html(l.prop("outerHTML")).get(0)), d.addRange(r), (t = jquery(n).children().last()).children("li").length && (t = t.children("li").last()), d.selectAllChildren(t.get(0)), d.collapseToEnd()) : (d.collapse(i, a), document.execCommand("formatBlock", false, "<" + e + ">"))
			};
			thiz.html = function (str) {
				if (!str) {
					var txt = editor.html().replace(/<(\/?)(p)>/g, "<$1h3>");
					window.android && window.android.html(txt);
					window.webkit && window.webkit.messageHandlers.html.postMessage(txt);
					return txt;
				}
				var sel = utils.getSelection();
				var node;
				editor.empty().html(str);//content = decodeURIComponent(str)
				var offY = editor.prop("scrollHeight") - jquery(window).height();
				editor.children().length && (node = editor.children().last());
				if (node) {
					node.children("ol,ul").length && (node = node.children("ol,ul").last());
				}
				else {
					node = editor
				}
				window.scrollTo(0, offY);
				editor.scrollTop(offY);
				editor.focus();
				sel.selectAllChildren(node.get(0));
				sel.collapseToEnd();
				window.webkit && setTimeout(function () {
					adjust(editId)
				}, 500)
			};
			thiz.text = function (e) {
				if (!e && "" !== jquery.trim(e)) {
					return editor.text();
				}
				editor.empty().html(decodeURIComponent(e))
			};
			thiz.focus = function () {
				var e = myEditor.blurRange,
					n = utils.getSelection();
				editor.is(":focus") || editor.focus(), e && n.collapse(e.endContainer, e.endOffset)
			};
			thiz.blur = function () {
				editor.blur()
			};
			thiz.maxTextLength = function (len) {
				maxLen = len
			};
			thiz.selectAll = function () {
				document.execCommand("selectAll", false, null)
			};
			["bold", "italic", "underline", "foreColor"].map(function (cmd) {
				thiz[cmd] = function (param) {
					var range, selRange = myEditor.blurRange,
						endContainer = selRange.endContainer,
						endOffset = selRange.endOffset,
						blockNode = utils.findBlockNode(endContainer),
						args = param || null,
						sel = utils.getSelection();
					if (utils.findParentsNode(endContainer, "a").length)
						sel.collapse(endContainer, endOffset);
					else if (selRange.collapsed)
						if ("" === blockNode.text())
							sel.collapse(endContainer, endOffset),
							document.execCommand(cmd, false, args),
							param && "LI" === blockNode.get(0).nodeName.toUpperCase() && blockNode.css("color", param);
						else {
							sel.removeAllRanges(),
								(range = document.createRange()).selectNodeContents(blockNode.get(0)),
								sel.addRange(range),
								document.execCommand(cmd, false, args),
								param && "LI" === blockNode.get(0).nodeName.toUpperCase() && blockNode.css("color", param);
							try {
								sel.collapse(endContainer, endOffset)
							} catch (err) {
								sel.collapseToEnd(), console.log(err)
							}
						}
					else {
						sel.removeAllRanges();
						sel.addRange(selRange);
						document.execCommand(cmd, false, args)
					}
				}
			});
			["justifyLeft", "justifyCenter", "justifyRight"].map(function (cmd) {
				thiz[cmd] = function () {
					var range = myEditor.blurRange,
						sel = utils.getSelection();
					sel.collapse(range.endContainer, range.endOffset);
					document.execCommand(cmd, false, null)
					thiz.statesChanged();
				}
			});
			["undo", "redo"].map(function (cmd) {
				thiz[cmd] = function () {
					document.execCommand(cmd, false, null)
				}
			});
		}
	}.call(null, window.jQuery || window.$))
}(),

function (e) {
	"use strict";
	window.jQuery(function () {
		(function (jquery) {
			var editor = jquery("#my_editor");
			for (var n in window.meditor = new MEditor(editor), window.commands = meditor.commands(), window.meditor) {
				window[n] = window.meditor[n];
			}
			window.android && window.android.ready(JSON.stringify({
				isReady: true
			}));
			window.webkit && window.webkit.messageHandlers.ready.postMessage(JSON.stringify({
				isReady: true
			}));
			meditor.listenerSelectionChange(function (e) {
				(window.android || window.webkit) && (window.location.href = "re-state://" + e.join(","))
			});
			jquery(window).on("touchmove", function () {
				window.webkit && (window.location.href = "re-scroll://" + window.pageYOffset)
			});
			window.android || window.webkit ? true : (editor.focus(), meditor.html(function () {
				for (var e = [], n = 0; n < 5; n++) {
					e.push("<h3><ul><li>" + (new Date).getTime() + n + "<b>粗体测试</b>测试内容</li></ul></h3>");
				}
				return e.join("")
			}()));

			window.RE = {};
			RE.setHtml = function (contents) {
				meditor.html(contents);
			};

			RE.getHtml = function () {
				meditor.html();
			};

			RE.getText = function () {
				meditor.text();
			}

			RE.undo = function () {
				meditor.undo();
			}

			RE.redo = function () {
				meditor.redo();
			}

			RE.setBold = function () {
				meditor.bold();
			}

			RE.setItalic = function () {
				meditor.italic();
			}

			RE.setUnderline = function () {
				meditor.underline();
			}

			RE.setBullets = function () {
				meditor.insertUnorderedList();
			}

			RE.setNumbers = function () {
				meditor.insertOrderedList();
			}
			RE.setOrderedList = function () {
				meditor.insertOrderedList();
			}
			RE.setUnorderedList = function () {
				meditor.insertUnorderedList();
			}
			RE.setTextColor = function (color) {
				meditor.foreColor(color);
			}

			RE.setHeading = function (heading) {
				meditor.foramtParagraph("h" + heading);
			}
			// RE.setIndent = function () {
			// 	window.location.href = "re-state://" + meditor.commands().join(",")
			// }
			// RE.setIndent = function () {
			// 	document.execCommand('indent', false, null);
			// }

			// RE.setOutdent = function () {
			// 	document.execCommand('outdent', false, null);
			// }

			RE.setJustifyLeft = function () {
				meditor.justifyLeft();
			}

			RE.setJustifyCenter = function () {
				meditor.justifyCenter();
			}

			RE.setJustifyRight = function () {
				meditor.justifyRight();
			}

			RE.insertLink = function (url, title) {
				meditor.createLink(title, url);
			};
			RE.updateLink = function (url, title) {
				meditor.updateLink(title, url);
			};
			RE.deleteLink = function () {
				meditor.deleteLink();
			};
			RE.focus = function () {
				meditor.focus();
			};
			RE.prepareInsert = function () {

			};
			RE.removeFormat = function () {

			};
			RE.callback = function () {
				meditor.html(); //回调更新内容
			};
			RE.setPlaceholder = function (placeholder) {
				editor.attr("placeholder", placeholder);
			}
			RE.setBaseTextColor = function (color) {
				editor.css("color", color);
			}

			RE.setBaseFontSize = function (size) {
				editor.css("font-size", size);
			}

			RE.setPadding = function (left, top, right, bottom) {
				editor.css("padding-left", left);
				editor.css("padding-top", top);
				editor.css("padding-right", right);
				editor.css("padding-bottom", bottom);
			}
		}).apply(window, [window.jQuery])
	})
}();
