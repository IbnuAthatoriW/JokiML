<?php

namespace App\Services;

class RankingSystem
{
    /**
     * Define rank ranges and their properties
     */
    public const RANKS = [
        'Mythic' => [
            'min_star' => 0,
            'max_star' => 24,
            'display_name' => 'Mythic',
        ],
        'Mythic Honor' => [
            'min_star' => 25,
            'max_star' => 49,
            'display_name' => 'Mythic Honor',
        ],
        'Mythic Glory' => [
            'min_star' => 50,
            'max_star' => 99,
            'display_name' => 'Mythic Glory',
        ],
        'Immortal' => [
            'min_star' => 100,
            'max_star' => 9999,
            'display_name' => 'Immortal',
        ],
    ];

    /**
     * Get all valid ranks
     */
    public static function getAllRanks(): array
    {
        return array_keys(self::RANKS);
    }

    /**
     * Get rank details by name
     */
    public static function getRankDetails(string $rankName): ?array
    {
        return self::RANKS[$rankName] ?? null;
    }

    /**
     * Validate if stars are in valid range for the given rank
     */
    public static function validateStarInRank(string $rankName, int $stars): bool
    {
        $rankDetails = self::getRankDetails($rankName);
        if (!$rankDetails) {
            return false;
        }

        return $stars >= $rankDetails['min_star'] && $stars <= $rankDetails['max_star'];
    }

    /**
     * Get rank name by stars
     */
    public static function getRankByStars(int $stars): ?string
    {
        foreach (self::RANKS as $rankName => $details) {
            if ($stars >= $details['min_star'] && $stars <= $details['max_star']) {
                return $rankName;
            }
        }
        return null;
    }

    /**
     * Get all stars in valid range for a rank
     */
    public static function getStarRange(string $rankName): ?array
    {
        $rankDetails = self::getRankDetails($rankName);
        if (!$rankDetails) {
            return null;
        }

        return [
            'min' => $rankDetails['min_star'],
            'max' => $rankDetails['max_star'],
        ];
    }

    /**
     * Check if two rank-star combinations are valid
     */
    public static function validateRankStarPair(string $rankName, int $stars): bool
    {
        return self::validateStarInRank($rankName, $stars);
    }
}
