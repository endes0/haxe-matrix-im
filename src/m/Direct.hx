package m;

import beartek.matrix_im.client.types.Room;
import beartek.matrix_im.client.types.User;

typedef Direct = {
    var rooms: Map<User, Room>;
}