<?php

namespace App\Services;

class RankCalculator
{
    /**
     * Calculate price for a custom order that may span multiple ranks
     *
     * @param string $fromRank Starting rank
     * @param int $fromStar Starting stars
     * @param string $toRank Ending rank
     * @param int $toStar Ending stars
     * @param array $pricePerRank Price mapping per rank (rank name => price per star)
     * @return array ['total_price' => float, 'breakdown' => array]
     */
    public static function calculatePrice(
        string $fromRank,
        int $fromStar,
        string $toRank,
        int $toStar,
        array $pricePerRank
    ): array {
        // Validate inputs
        if (!RankingSystem::validateStarInRank($fromRank, $fromStar)) {
            throw new \InvalidArgumentException(
                "Star {$fromStar} tidak valid untuk rank {$fromRank}"
            );
        }

        if (!RankingSystem::validateStarInRank($toRank, $toStar)) {
            throw new \InvalidArgumentException(
                "Star {$toStar} tidak valid untuk rank {$toRank}"
            );
        }

        // Check if from is before to
        $fromAbsoluteStar = self::getAbsoluteStarPosition($fromRank, $fromStar);
        $toAbsoluteStar = self::getAbsoluteStarPosition($toRank, $toStar);

        if ($fromAbsoluteStar >= $toAbsoluteStar) {
            throw new \InvalidArgumentException(
                "Rank/star awal tidak boleh lebih tinggi atau sama dengan rank/star tujuan"
            );
        }

        $breakdown = [];
        $totalPrice = 0;
        $ranks = RankingSystem::getAllRanks();
        $started = false;

        foreach ($ranks as $rank) {
            if (!$started) {
                if ($rank !== $fromRank) {
                    continue;
                }
                $started = true;
            }

            $rankDetails = RankingSystem::getRankDetails($rank);
            if (!$rankDetails) {
                continue;
            }

            if ($rank === $fromRank && $rank === $toRank) {
                $starsCount = $toStar - $fromStar;
                $fromStarValue = $fromStar;
                $toStarValue = $toStar;
            } elseif ($rank === $fromRank) {
                $starsCount = $rankDetails['max_star'] - $fromStar + 1;
                $fromStarValue = $fromStar;
                $toStarValue = $rankDetails['max_star'];
            } elseif ($rank === $toRank) {
                $starsCount = $toStar - $rankDetails['min_star'];
                $fromStarValue = $rankDetails['min_star'];
                $toStarValue = $toStar;
            } else {
                $starsCount = $rankDetails['max_star'] - $rankDetails['min_star'] + 1;
                $fromStarValue = $rankDetails['min_star'];
                $toStarValue = $rankDetails['max_star'];
            }

            if ($starsCount > 0) {
                $pricePerStar = $pricePerRank[$rank] ?? 0;
                $breakdown[] = [
                    'rank' => $rank,
                    'from_star' => $fromStarValue,
                    'to_star' => $toStarValue,
                    'stars_count' => $starsCount,
                    'price_per_star' => $pricePerStar,
                    'total_price' => $starsCount * $pricePerStar,
                ];
                $totalPrice += $starsCount * $pricePerStar;
            }

            if ($rank === $toRank) {
                break;
            }
        }

        return [
            'total_price' => $totalPrice,
            'breakdown' => $breakdown,
            'from_rank' => $fromRank,
            'from_star' => $fromStar,
            'to_rank' => $toRank,
            'to_star' => $toStar,
        ];
    }

    /**
     * Get absolute star position across all ranks for comparison
     */
    private static function getAbsoluteStarPosition(string $rank, int $stars): int
    {
        $position = 0;
        $ranks = RankingSystem::getAllRanks();

        foreach ($ranks as $currentRank) {
            if ($currentRank === $rank) {
                $rankDetails = RankingSystem::getRankDetails($rank);
                return $position + ($stars - $rankDetails['min_star']);
            }

            $rankDetails = RankingSystem::getRankDetails($currentRank);
            $position += ($rankDetails['max_star'] - $rankDetails['min_star'] + 1);
        }

        return $position;
    }

    /**
     * Format breakdown for display
     */
    public static function formatBreakdown(array $priceData): string
    {
        if (empty($priceData['breakdown'])) {
            return "Tidak ada breakdown";
        }

        $lines = [];
        foreach ($priceData['breakdown'] as $item) {
            $lines[] = sprintf(
                "%s ⭐%d-⭐%d (%d ⭐) → Rp%,d × %d = Rp%,d",
                $item['rank'],
                $item['from_star'],
                $item['to_star'],
                $item['stars_count'],
                $item['price_per_star'],
                $item['stars_count'],
                $item['total_price']
            );
        }

        $lines[] = '';
        $lines[] = sprintf("Total: Rp%,d", $priceData['total_price']);

        return implode("\n", $lines);
    }
}
