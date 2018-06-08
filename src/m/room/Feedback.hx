//Under GNU AGPL v3, see LICENCE
package m.room;

import beartek.matrix_im.client.types.enums.Feedbacks;

typedef Feedback = {
    var target_event_id : String;
    var type : Feedbacks;
};