#  Projet Développement iOS

Brice JACQUESSON — Anaël BARODINE
M2 IMIS mars 2024

## Présentation de l'application
L'application "TodoList" se présente sous la forme de trois vues dont le passage de l'une aux autres se fait par des boutons prévus à cet effet :
- Liste des tâches ;
- Ajout d'une tâche ;
- Détails d'une tâche, servant également de vue d'édition d'une tâche.

### Liste des tâches
Les tâches se présentent sous la forme d'une liste sur l'écran principal de l'application. Par défaut, elles sont triées par importance (les tâches marquées "importantes" plus haut que les autres), puis par date (les tâches d'une même importance dont l'échéance est la plus antérieur avant). Les tâches terminées sont mises à la fin de la liste.

Chaque tâche se compose au moins d'un titre ainsi que d'une échéance, indiqués sur chacune dans la liste. Les tâches importantes sont marquées d'un double point d'exclamation "!!" à gauche de leur titre. Les tâches terminées sont entièrement grisées. Une tâche peut être indiquée comme terminée en la faisant glisser vers la droite. Une tâche peut être supprimée en la faisant glisser vers la gauche. En touchant une tâche, cela permet d'accéder à l'écran de détail d'une tâche, qui est aussi l'écran d'édition.

Il est possible de recharger les tâches en faisant glisser la liste vers le bas. Normalement, cela n'est jamais nécessaire parce que la liste se met à jour à chaque changement.

En haut de la liste on peut choisir un tri alternatif par date d'échéance, sans prendre en compte l'importance des tâches. Les tâches terminées seront en bas quoi qu'il arrive. En haut à droite se trouve un symbole "+" qui est un bouton amenant l'utilisateur à l'écran de création des tâches. En haut à droite se trouve un rouage qui est un bouton proposant à l'utilisateur de choisir entre afficher ou non les tâches terminées. Il est aussi possible dans ce petit menu de supprimer toutes les tâches d'un coup.

### Ajout d'une tâche
Sur l'écran d'ajout d'une tâche, l'utilisateur est invité à saisir dans des champs de texte le nom de la tâche et une déscription (pouvant rester vide), ainsi qu'une date et heure d'échéance. Il est également possible via un interupteur d'identifier la tâche comme importante. Un autre interupteur permet de saisir une adresse géographique par le biais de quatre champs : adresse (rue et numéro de rue), code postal, ville et pays. Un bouton bleu "Créer la tâche" en bas de l'écran permet de valider la création de la tâche. Une fois touché, l'application vérifie que le champ de titre n'est pas vide et que l'adresse est bien existante, sous peine de pop-up de refus de création avec un message explicatif.

Une fois une tâche créée, l'utilisateur est ramené à l'écran de liste des tâches.

### Détails/édition d'une tâche
Une fois une tâche sélectionnée, l'écran de détails d'une tâche permet de voir les attributs de cette dernière. Tout d'abord le titre, en en-tête, et la description, ainsi que la date d'échéance. Si la tâche dispose d'une adresse, alors un plan localisant l'adresse est affiché ainsi que quelques informations météo : la température moyenne, les températures maximales et minimales, et une icône correspondant à la météo actuelle. Si aucune adresse n'est renseignée, alors ces deux derniers éléments sont absents (invisibles).

Il est possible de passer en mode édition à l'aide du bouton crayon en haut à droite. En outre, il est aussi possible de revenir à la liste des tâches via le bouton "Retour" en haut à gauche.

Une fois en mode édition, le plan et la météo, si affichés, s'éclipsent. Le titre de la tâche, la description ainsi que la date d'échéance se dégrisent pour se laisser modifier. Également, un interupteur "Tâche importante" permet de changer l'importance de la tâche et un interupteur "Ajouter ou modifier l'adresse" permet de rendre visible les quatre champs d'adresse et de les modifier. En bas de l'écran, deux boutons "Annuler" et "Confirmer" permettent de réaliser les actions équivoques. Il est aussi possible d'annuler l'édition en touchant le crayon en haut à droite ou le bouton "Retour" en haut à gauche. Tout comme pour l'ajout de tâche, une vérification du titre et de l'adresse sont faites.

Une fois l'édition confirmée, la tâche se met à jour et le mode édition disparaît pour laisser de nouveau place à l'écran de détails de la tâche.



## API/BD utilisé

On utilisa la même api utilisé en cours pour récupéré la météo, ainsi qu'un CLgeocoder pour récupéré les localisations de nos adresses.

Les données sont sauvegarder via CoreData et une entité Tache qui contient les attributs voulus. La préférence d'affichage pour les tâches terminées est quant-a elle stocker via UserDefault puisqu'il s'agit d'un type primitif et surtout pour expérimenter les 2 façons de faire.
    
## Difficultés rencontrées

Le but de l'application est de faire une todolist, c'est le genre d'application où la prise en main est hyper importante. Donc la première difficulté à été de rendre l'app agréable, en rendant toutes les actions par des gestes ou des visuels classique. De plus rendre la page de détail et de modification identique a rendu difficile l'agencement de la view.

Les tris demandés ont été implémentés, cependant, on a commencé par étudier l'option des NSSortDescriptor pour trier le fetch via CoreData, mais le tri était parfois incorrect, donc on a appliquer le tri directement sur la liste des taches récupéré.

Une autre difficulté a été la vérification de l'adresse. Vérifier qu'une adresse existe est assez variable avec CLGeocoder puisque même avec une adresse très peu précise il peut trouver une adresse et une localisation. Donc on a permis à l'utilisateur de rentré l'adresse voulu et si l'adresse n'est pas la bonne il peut la modifier dans sa tache.
