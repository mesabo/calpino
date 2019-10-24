===============BASE MODEL===============
Dans cette classe nous créons toutes les fonctions nécessaires et communes à toutes
les autres class.
Nous avons justement trois méthodes:
*setchosenDate: est appellée pour faire passer une date.
*setStackIndex: gère le basculement entre écran d'affichage et de saisi; on pouvait très
bien utiliser un statafullwidget, mais celle-ci est bien plus adaptée à notre situation.
*loadData: Qu'on ajoute ou supprime une entité, la liste des entités doit etre actualisée
à chaque fois; donc cette méthode vie pour ça !

===============UTILS===============
kipreéboris@gmail.com: réunion du 23/10/2019
recherche de new partenaire

le partenaire a une obligation de moyens et de résultats.
Venir en tant qu'un individu ou en tant que structure.

Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: .25,
                        child: Card(
                          elevation: 8,
                          child: ListTile(
                            title: Text(
                              "${user.name}",
                            ),
                            subtitle: Text("${user.email}"),
                          ),
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: "Supprimer",
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              _deleteUser(inContext, user);
                            },
                          ),
                          IconSlideAction(
                              caption: "Editer",
                              color: Colors.green,
                              icon: Icons.update,
                              onTap: () async {
                                userModel.entityBeingEdited =
                                    await UserDBWorker.db.getUser(user.id);
                                userModel.setStackIndex(1);
                              }),
                        ],
                      );