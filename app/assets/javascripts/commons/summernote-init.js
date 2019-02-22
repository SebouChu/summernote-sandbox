/*global $, document, window, console, FormData */

$.extend($.summernote.lang['en-US'].image, {
    dragImageHere: 'Drag image here',
    dropImage: 'Drop image'
});

var sendFile = function (file, toSummernote) {
    'use strict';
    var data;
    data = new FormData();
    data.append('file', file);
    $.ajax({
        data: data,
        type: 'POST',
        url: '/uploads',
        cache: false,
        contentType: false,
        processData: false,
        success: function (data) {
            console.log('file uploading...');
            if (data.errors !== undefined && data.errors !== null) {
                console.log('ops! errors...');
                return $.each(data.errors, function (key, messages) {
                    return $.each(messages, function (key, message) {
                        return window.alert(message);
                    });
                });
            }
            console.log('inserting image in to editor...');
            return toSummernote.summernote('pasteHTML', data.node);
        }
    });
};

window.summernoteConfig = {
    height: 400,
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
        },
        onImageUpload: function (files, e) {
            'use strict';
            sendFile(files[0], $(this));
        }
    },
    toolbar: [
        ['headline', ['style']],
        ['style', ['bold', 'italic']],
        ['alignment', ['ul', 'ol', 'paragraph']],
        ['insert', ['hr']],
        ['link', ['linkDialogShow', 'unlink']],
        ['media', ['picture']],
        ['code', ['codeview']]
    ],
    styleTags: ['p', 'blockquote', 'pre', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'],
    popover: {
        image: [
            ['remove', ['removeMedia']]
        ]
    }
};

$(function () {
    'use strict';
    $('[data-provider=summernote]').summernote(window.summernoteConfig);
});
