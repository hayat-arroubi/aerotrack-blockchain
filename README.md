# AeroTrack — Provenance des pièces d'avion sur Ethereum

Smart contract Solidity qui sécurise la traçabilité des pièces détachées d'avion
via la blockchain Ethereum. Réalisé dans le cadre du laboratoire de Blockchain
Industrielle (Filière Génie Logiciel et Digitalisation, ENSEM — Université Hassan II
de Casablanca).

## Objectif

Remplacer les certificats papier falsifiables (EASA Form 1, FAA 8130-3) par un
registre immuable et décentralisé. Chaque pièce est suivie de sa fabrication à sa
maintenance, avec un contrôle d'accès garantissant que seules les entités
autorisées peuvent agir.

## Fonctionnalités

- **Enregistrement** d'une pièce par son fabricant (`manufacturePart`)
- **Transfert de propriété** sécurisé (`transferPart`)
- **Journalisation de maintenance** traçable (`logMaintenance`)
- **Contrôle d'accès basé sur les rôles (RBAC)** via des modifiers
- **Traçabilité** par les events Ethereum (peu coûteux en gas)

## Stack technique

- Solidity `^0.8.19`
- Remix IDE (Remix VM pour les tests)

## Architecture

- `enum PartStatus` : Manufactured, InTransit, Installed, Retired
- `struct Part` : numéro de série, nom, fabricant, propriétaire actuel, statut, drapeau `exists`
- `mapping(uint256 => Part)` : associe un numéro de série à sa pièce
- Modifiers : `onlyAuthority`, `partExists`, `onlyPartOwner`

## Déploiement et test (Remix IDE)

1. Ouvrir [Remix IDE](https://remix.ethereum.org/) et créer `AeroTrack.sol`.
2. Coller le code, compiler avec la version `0.8.19`.
3. Onglet *Deploy & Run* → environnement **Remix VM** → **Deploy**.
4. Simuler la chaîne d'approvisionnement avec plusieurs comptes :
   - Compte 1 (Fabricant) : `manufacturePart(999, "Boeing 737 Landing Gear")`
   - Compte 3 (Hacker) : tenter `transferPart` → échec attendu ("You do not own this part")
   - Compte 1 → Compte 2 : `transferPart` légitime → succès
   - Compte 2 (Compagnie) : `logMaintenance` → succès

## Auteur

Hayat ARROUBI — ENSEM, Université Hassan II de Casablanca
Encadré par : Khalid BOKHDIR — Année universitaire 2024–2025