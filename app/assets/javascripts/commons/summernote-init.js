/*global $, document, window */

window.summernoteConfig = {
    height: 400,
    disableDragAndDrop: true,
    callbacks: {
        onPaste: function (event) {
            'use strict';
            event.preventDefault();
            var paragraph = document.createElement('p');
            paragraph.textContent = ((event.originalEvent || event).clipboardData || window.clipboardData).getData('Text').trim();
            if ((window.getSelection !== undefined ? window.getSelection() : document.selection.createRange()).toString().length > 0) {
                document.execCommand('delete', false);
            }
            document.execCommand('insertHTML', false, paragraph.outerHTML);
        },
        onInit: function () {
            'use strict';
            $(this).summernote('removeModule', 'autoLink');
        },
        onApplyCustomStyle: function ($target, context, onFormatBlock) {
            'use strict';
            if ($target.hasClass('dropdown-item')) {
                $target = $target.children().first();
            }
            onFormatBlock($target.prop('tagName'), $target);
        }
    },
    toolbar: [
        ['headline', ['style']],
        ['style', ['bold', 'italic']],
        ['alignment', ['ul', 'ol', 'paragraph']],
        ['insert', ['hr']],
        ['link', ['linkDialogShow', 'unlink']],
        ['code', ['codeview']]
    ],
    styleTags: ['p', 'blockquote', 'pre', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6']
};

$(function () {
    'use strict';
    $('[data-provider=summernote]').summernote(window.summernoteConfig);
});
