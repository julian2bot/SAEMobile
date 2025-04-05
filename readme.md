
# SAE Mobile

Julian MARQUES (Chef de projet)  
Chris MATHEVET  
Yohann VILCOQ  
Carel RIBALTCHENKO  

## Lien du site  
Nous avons compilé l'application, donc nous avons un APK.

[**Télécharger**](/APK/app-release.apk)

## Les Mdp dans `pass.csv`  
Pour se connecter à Supabase depuis l'application (si vous prenez le Git), il faudra que vous ayez les accès à la BD, mais ils sont dans un fichier `pass.csv` dans "assets/". Si vous les voulez, veuillez nous contacter.

## Installation  

### BD  
Aller sur Supabase, se créer un compte et créer un nouveau projet.  

Une fois le projet créé, il suffit d'aller dans **SQL Editor**.  
En haut à gauche, on peut chercher les requêtes et, à côté, il y a un bouton **+**. Il faut cliquer dessus puis sur **Create a new snippet**.  

On met dedans le script de la création de la table, puis on clique sur **Run** en bas à droite. On voit que tout a été créé et, dans les catégories à gauche, dans **PRIVATE**, on peut le déplacer à **SHARED** pour qu'il soit visible par tous.  
Une fois la table créée, on a tout.  

Pour créer la table sur MariaDB, c'est simplement une création de BD :  
`CREATE DATABASE name;`  
Puis, il suffit de copier-coller le script de création.  

### L'application  

Pour lancer le site, il suffit d'aller à la racine du projet et d'exécuter la commande :  
```sh
flutter run
```

Puis, suivre la démarche soit choisir sur quoi exécuter.  

#### Utils  
Si la BD est vide ou si vous recréez la BD, vous devez exécuter le fichier `remplirBD.bat` ou `remplirBD.sh` selon votre distribution. Mais cela depuis notre SAE PHP précédemment faite :  
[ICI](https://github.com/julian2bot/SAEPHP)

### Fonctionnalités  

#### Principal  
- Recherche de restaurants dynamique (en cherchant avec le nom et sans refresh de la page, on récupère et affiche les restaurants de la BD).  
- Recommandation en fonction des restaurants mis en favoris (prend les restos similaires).  
- Ajout aux favoris.  
- Voir les favoris.  
- Ajout de cuisine aux favoris.  
- Voir les cuisines favoris.  
- Visualiser les restaurants avec leurs adresses, images, noms, etc.  
  - Les images sont obtenues via la BD s'il y en a.  
  - Sinon, les images sont obtenues via un commentaire.  
  - S'il n'y a pas d'image dans la BD ni dans les commentaires, une image **placeholder** s'affiche.  

- Commentaires et notes sous un restaurant  
  - **Déconnecté**  
    - Voir les autres commentaires.  
  - **Connecté**  
    - Ajout  
    - Suppression  
    - Modification  
  - Sur les commentaires, il est possible d'ajouter une image de la galerie ou de la caméra (ainsi que de voir dans les commentaires les images postées).

- **Administrateur**  
  - Suppression de tous les commentaires.  

- **Profil**  
  - Se connecter  
  - Se déconnecter  
  - Modifier son nom  

