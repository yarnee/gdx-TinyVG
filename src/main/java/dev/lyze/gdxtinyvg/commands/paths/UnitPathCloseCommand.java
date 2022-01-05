package dev.lyze.gdxtinyvg.commands.paths;

import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.utils.Array;
import com.badlogic.gdx.utils.LittleEndianInputStream;
import dev.lyze.gdxtinyvg.enums.Range;
import dev.lyze.gdxtinyvg.enums.UnitPathCommandType;
import dev.lyze.gdxtinyvg.types.Unit;
import dev.lyze.gdxtinyvg.types.Vector2WithWidth;
import java.io.IOException;

/**
 * A straight line is drawn to the start location of the current segment. This
 * instruction doesn't have additional data encoded.
 */
public class UnitPathCloseCommand extends UnitPathCommand {
    public UnitPathCloseCommand(Unit lineWidth) {
        super(UnitPathCommandType.CLOSE_PATH, lineWidth);
    }

    @Override
    public void read(LittleEndianInputStream stream, Range range, int fractionBits) throws IOException {
    }

    @Override
    public Array<Vector2WithWidth> calculatePoints(Vector2 start, float lastLineWidth) {
        // We don't need to store points here as start and end are already tracked by
        // other commands.
        // Additionally, shape drawer gets confused when end point = start point in a
        // polygon
        return new Array<>();
    }
}